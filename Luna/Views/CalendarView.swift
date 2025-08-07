//
//  CalendarView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\HormoneReading.date, order: .reverse)]) private var hormoneReadings: [HormoneReading]
    @Query(sort: [SortDescriptor(\SymptomLog.date, order: .reverse)]) private var symptomLogs: [SymptomLog]
    @Query(sort: [SortDescriptor(\CycleData.cycleStart, order: .reverse)]) private var cycleData: [CycleData]
    
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var showingDayDetail = false
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Month Header with Navigation
                MonthHeaderView(
                    currentMonth: $currentMonth,
                    dateFormatter: dateFormatter
                )
                
                // Calendar Grid
                CalendarGridView(
                    currentMonth: currentMonth,
                    selectedDate: $selectedDate,
                    showingDayDetail: $showingDayDetail,
                    hormoneReadings: hormoneReadings,
                    symptomLogs: symptomLogs,
                    cycleData: cycleData
                )
                
                // Legend
                CalendarLegendView()
                
                Spacer()
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingDayDetail) {
                DayDetailView(
                    selectedDate: selectedDate,
                    hormoneReadings: hormoneReadings,
                    symptomLogs: symptomLogs,
                    cycleData: cycleData
                )
            }
        }
    }
}

// MARK: - Month Header View
struct MonthHeaderView: View {
    @Binding var currentMonth: Date
    let dateFormatter: DateFormatter
    private let calendar = Calendar.current
    
    var body: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.pink)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.pink)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
}

// MARK: - Calendar Grid View
struct CalendarGridView: View {
    let currentMonth: Date
    @Binding var selectedDate: Date
    @Binding var showingDayDetail: Bool
    let hormoneReadings: [HormoneReading]
    let symptomLogs: [SymptomLog]
    let cycleData: [CycleData]
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var monthDays: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        let monthStart = monthInterval.start
        
        // Get first day of the week for the month
        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let startDate = calendar.date(byAdding: .day, value: -(firstWeekday - 1), to: monthStart) ?? monthStart
        
        // Generate 42 days (6 weeks)
        return (0..<42).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startDate)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Days of week header
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            
            // Calendar days grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 1) {
                ForEach(monthDays, id: \.self) { date in
                    CalendarDayCell(
                        date: date,
                        currentMonth: currentMonth,
                        selectedDate: $selectedDate,
                        showingDayDetail: $showingDayDetail,
                        cyclePhase: getCyclePhase(for: date),
                        hasData: hasDataForDate(date)
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func getCyclePhase(for date: Date) -> CyclePhase {
        let dayStart = calendar.startOfDay(for: date)
        
        // Find the cycle that contains this date
        guard let cycle = cycleData.first(where: { cycle in
            let cycleStart = calendar.startOfDay(for: cycle.cycleStart)
            let cycleEnd = cycle.cycleEnd.map { calendar.startOfDay(for: $0) } ?? Date()
            return dayStart >= cycleStart && dayStart <= cycleEnd
        }) else {
            return .unknown
        }
        
        let daysSinceStart = calendar.dateComponents([.day], from: cycle.cycleStart, to: date).day ?? 0
        
        // Determine phase based on cycle day
        if daysSinceStart <= 5 {
            return .menstrual
        } else if daysSinceStart <= 13 {
            return .follicular
        } else if daysSinceStart <= 16 {
            return .ovulatory
        } else {
            return .luteal
        }
    }
    
    private func hasDataForDate(_ date: Date) -> Bool {
        let dayStart = calendar.startOfDay(for: date)
        
        return hormoneReadings.contains { reading in
            calendar.isDate(reading.date, inSameDayAs: dayStart)
        } || symptomLogs.contains { log in
            calendar.isDate(log.date, inSameDayAs: dayStart)
        }
    }
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let date: Date
    let currentMonth: Date
    @Binding var selectedDate: Date
    @Binding var showingDayDetail: Bool
    let cyclePhase: CyclePhase
    let hasData: Bool
    
    private let calendar = Calendar.current
    
    var isCurrentMonth: Bool {
        calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    var isSelected: Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    var body: some View {
        Button(action: {
            selectedDate = date
            showingDayDetail = true
        }) {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 16, weight: isToday ? .bold : .medium))
                    .foregroundColor(textColor)
                
                // Data indicator dots
                HStack(spacing: 2) {
                    if hasData {
                        Circle()
                            .fill(Color.pink)
                            .frame(width: 4, height: 4)
                    }
                    
                    if cyclePhase != .unknown {
                        Circle()
                            .fill(cyclePhase.color)
                            .frame(width: 4, height: 4)
                    }
                }
                .frame(height: 6)
            }
            .frame(width: 40, height: 50)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return .secondary
        } else if isToday {
            return .primary
        } else {
            return .primary
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .pink.opacity(0.2)
        } else if isToday {
            return .pink.opacity(0.1)
        } else if cyclePhase != .unknown {
            return cyclePhase.color.opacity(0.1)
        } else {
            return .clear
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            return .pink
        } else if isToday {
            return .pink.opacity(0.5)
        } else {
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        (isSelected || isToday) ? 1.5 : 0
    }
}

// MARK: - Calendar Legend
struct CalendarLegendView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Legend")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                LegendItem(color: .pink, title: "Data Logged")
                LegendItem(color: CyclePhase.menstrual.color, title: "Menstrual")
                LegendItem(color: CyclePhase.follicular.color, title: "Follicular")
                LegendItem(color: CyclePhase.ovulatory.color, title: "Ovulatory")
                LegendItem(color: CyclePhase.luteal.color, title: "Luteal")
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
        .background(Color(.systemGroupedBackground))
    }
}

struct LegendItem: View {
    let color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

// MARK: - Cycle Phase Enum
enum CyclePhase {
    case menstrual, follicular, ovulatory, luteal, unknown
    
    var color: Color {
        switch self {
        case .menstrual:
            return .red
        case .follicular:
            return .orange
        case .ovulatory:
            return .green
        case .luteal:
            return .purple
        case .unknown:
            return .gray
        }
    }
    
    var name: String {
        switch self {
        case .menstrual:
            return "Menstrual"
        case .follicular:
            return "Follicular"
        case .ovulatory:
            return "Ovulatory"
        case .luteal:
            return "Luteal"
        case .unknown:
            return "Unknown"
        }
    }
}

#Preview {
    CalendarView()
        .modelContainer(for: [HormoneReading.self, SymptomLog.self, CycleData.self], inMemory: true)
}