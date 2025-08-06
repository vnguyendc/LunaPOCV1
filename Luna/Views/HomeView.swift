//
//  HomeView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\HormoneReading.date, order: .reverse)]) private var hormoneReadings: [HormoneReading]
    @Query(sort: [SortDescriptor(\CycleData.cycleStart, order: .reverse)]) private var cycleData: [CycleData]
    @State private var hasGeneratedMockData = false
    
    var todaysReading: HormoneReading? {
        let today = Calendar.current.startOfDay(for: Date())
        return hormoneReadings.first { reading in
            Calendar.current.isDate(reading.date, inSameDayAs: today)
        }
    }
    
    var currentCycle: CycleData? {
        return cycleData.first { cycle in
            cycle.cycleEnd == nil || cycle.cycleEnd! >= Date()
        }
    }
    
    var currentCycleDay: Int {
        guard let currentCycle = currentCycle else { return 1 }
        let daysDifference = Calendar.current.dateComponents([.day], from: currentCycle.cycleStart, to: Date()).day ?? 0
        return daysDifference + 1
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Today's Overview Header
                    TodayOverviewCard(cycleDay: currentCycleDay, currentCycle: currentCycle)
                    
                    // Ovulation Prediction Card
                    OvulationPredictionCard(currentCycle: currentCycle)
                    
                    // Today's Hormone Levels
                    TodaysHormoneCard(todaysReading: todaysReading)
                    
                    // Quick Actions
                    QuickActionsCard()
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            generateMockDataIfNeeded()
        }
    }
    
    private func generateMockDataIfNeeded() {
        if !hasGeneratedMockData && hormoneReadings.isEmpty {
            MockDataService.shared.generateMockData(in: modelContext)
            hasGeneratedMockData = true
        }
    }
}

// MARK: - Today Overview Card
struct TodayOverviewCard: View {
    let cycleDay: Int
    let currentCycle: CycleData?
    
    var phaseInfo: (name: String, color: Color) {
        guard let cycle = currentCycle else {
            return ("Unknown", .gray)
        }
        
        if let ovulationDate = cycle.ovulationDate {
            let daysFromOvulation = Calendar.current.dateComponents([.day], from: ovulationDate, to: Date()).day ?? 0
            if abs(daysFromOvulation) <= 1 {
                return ("Ovulation", .green)
            } else if daysFromOvulation > 1 {
                return ("Luteal Phase", .yellow)
            }
        }
        
        if cycleDay <= 5 {
            return ("Menstrual", .red)
        } else if cycleDay <= 13 {
            return ("Follicular Phase", .orange)
        } else {
            return ("Pre-Ovulatory", .orange)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today - Day \(cycleDay)")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Text(Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(phaseInfo.name)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(phaseInfo.color.opacity(0.2))
                .foregroundColor(phaseInfo.color)
                .cornerRadius(8)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Ovulation Prediction Card
struct OvulationPredictionCard: View {
    let currentCycle: CycleData?
    
    var predictionText: String {
        guard let cycle = currentCycle,
              let predictedOvulation = cycle.predictedOvulation else {
            return "Calculating..."
        }
        
        let daysUntil = Calendar.current.dateComponents([.day], from: Date(), to: predictedOvulation).day ?? 0
        
        if daysUntil == 0 {
            return "Predicted today"
        } else if daysUntil == 1 {
            return "Predicted tomorrow"
        } else if daysUntil > 0 {
            return "Predicted in \(daysUntil) days"
        } else {
            return "May have occurred \(-daysUntil) days ago"
        }
    }
    
    var confidenceText: String {
        guard let cycle = currentCycle else { return "Confidence: Low" }
        let percentage = Int(cycle.confidence * 100)
        let level = percentage > 85 ? "High" : percentage > 70 ? "Medium" : "Low"
        return "Confidence: \(level) (\(percentage)%)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🥚")
                    .font(.title)
                Text("Ovulation Forecast")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(predictionText)
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text(confidenceText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Estrogen rising")
                            .font(.caption)
                    }
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.orange)
                        Text("LH surge expected")
                            .font(.caption)
                    }
                    
                    HStack {
                        Image(systemName: "hourglass")
                            .foregroundColor(.gray)
                        Text("Awaiting progesterone rise")
                            .font(.caption)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Today's Hormone Card
struct TodaysHormoneCard: View {
    let todaysReading: HormoneReading?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("📊 Today's Hormone Levels")
                .font(.headline)
                .fontWeight(.semibold)
            
            if let reading = todaysReading {
                VStack(spacing: 8) {
                    if let lh = reading.lhLevel {
                        HormoneRowView(name: "LH", value: String(format: "%.1f mIU/ml", lh), trend: .rising, level: .high)
                    }
                    if let estrogen = reading.estrogenLevel {
                        HormoneRowView(name: "Estrogen", value: String(format: "%.0f pg/ml", estrogen), trend: .rising, level: .high)
                    }
                    if let progesterone = reading.progesteroneLevel {
                        HormoneRowView(name: "Progesterone", value: String(format: "%.1f ng/ml", progesterone), trend: .stable, level: .low)
                    }
                    if let fsh = reading.fshLevel {
                        HormoneRowView(name: "FSH", value: String(format: "%.1f mIU/ml", fsh), trend: .stable, level: .normal)
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Text("No hormone data for today")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: LogTestView()) {
                        Text("Record Today's Test")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.pink)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Hormone Row View
struct HormoneRowView: View {
    let name: String
    let value: String
    let trend: HormoneTrend
    let level: HormoneLevel
    
    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Image(systemName: trend.iconName)
                    .font(.caption)
                    .foregroundColor(trend.color)
                
                Text(level.displayName)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(level.color.opacity(0.2))
                    .foregroundColor(level.color)
                    .cornerRadius(4)
            }
        }
    }
}

// MARK: - Quick Actions Card
struct QuickActionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                NavigationLink(destination: LogTestView()) {
                    VStack {
                        Image(systemName: "testtube.2")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Log Test")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.pink)
                    .cornerRadius(10)
                }
                
                NavigationLink(destination: LogSymptomsView()) {
                    VStack {
                        Image(systemName: "heart.text.square")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Log Symptoms")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.purple)
                    .cornerRadius(10)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Supporting Enums
enum HormoneTrend {
    case rising, falling, stable
    
    var iconName: String {
        switch self {
        case .rising: return "arrow.up.right"
        case .falling: return "arrow.down.right"
        case .stable: return "minus"
        }
    }
    
    var color: Color {
        switch self {
        case .rising: return .green
        case .falling: return .red
        case .stable: return .gray
        }
    }
}

enum HormoneLevel {
    case low, normal, high
    
    var displayName: String {
        switch self {
        case .low: return "Low"
        case .normal: return "Normal"
        case .high: return "High"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .blue
        case .normal: return .green
        case .high: return .orange
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [HormoneReading.self, SymptomLog.self, CycleData.self], inMemory: true)
}