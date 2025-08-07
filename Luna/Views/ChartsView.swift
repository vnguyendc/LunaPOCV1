//
//  ChartsView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI
import SwiftData
import Charts

struct ChartsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\HormoneReading.date, order: .forward)]) private var hormoneReadings: [HormoneReading]
    @Query(sort: [SortDescriptor(\CycleData.cycleStart, order: .reverse)]) private var cycleData: [CycleData]
    
    @State private var selectedTimeRange: TimeRange = .lastMonth
    @State private var selectedHormones: Set<HormoneType> = [.lh, .estrogen]
    @State private var showingHormoneSelection = false
    
    private var filteredReadings: [HormoneReading] {
        let cutoffDate = selectedTimeRange.cutoffDate
        return hormoneReadings.filter { $0.date >= cutoffDate }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Range Selector
                    TimeRangeSelector(selectedRange: $selectedTimeRange)
                    
                    // Hormone Selection
                    HormoneSelectionCard(
                        selectedHormones: $selectedHormones,
                        showingSelection: $showingHormoneSelection
                    )
                    
                    // Main Chart
                    if !filteredReadings.isEmpty {
                        HormoneChartCard(
                            readings: filteredReadings,
                            selectedHormones: selectedHormones,
                            cycleData: cycleData,
                            timeRange: selectedTimeRange
                        )
                    } else {
                        NoDataChartCard()
                    }
                    
                    // Summary Stats
                    if !filteredReadings.isEmpty {
                        ChartSummaryCard(
                            readings: filteredReadings,
                            selectedHormones: selectedHormones,
                            timeRange: selectedTimeRange
                        )
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Charts")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingHormoneSelection) {
                HormoneSelectionSheet(selectedHormones: $selectedHormones)
            }
        }
    }
}

// MARK: - Time Range Enum
enum TimeRange: String, CaseIterable {
    case lastWeek = "1W"
    case lastMonth = "1M"
    case last3Months = "3M"
    case last6Months = "6M"
    
    var displayName: String {
        switch self {
        case .lastWeek: return "Last Week"
        case .lastMonth: return "Last Month"
        case .last3Months: return "3 Months"
        case .last6Months: return "6 Months"
        }
    }
    
    var cutoffDate: Date {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .lastWeek:
            return calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
        case .lastMonth:
            return calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .last3Months:
            return calendar.date(byAdding: .month, value: -3, to: now) ?? now
        case .last6Months:
            return calendar.date(byAdding: .month, value: -6, to: now) ?? now
        }
    }
}

// MARK: - Hormone Type Enum
enum HormoneType: String, CaseIterable {
    case lh = "LH"
    case fsh = "FSH"
    case estrogen = "Estrogen"
    case progesterone = "Progesterone"
    case e3g = "E3G"
    case pdg = "PdG"
    case testosterone = "Testosterone"
    case bbt = "BBT"
    
    var color: Color {
        switch self {
        case .lh: return .pink
        case .fsh: return .purple
        case .estrogen: return .blue
        case .progesterone: return .green
        case .e3g: return .orange
        case .pdg: return .red
        case .testosterone: return .brown
        case .bbt: return .cyan
        }
    }
    
    var unit: String {
        switch self {
        case .lh, .fsh: return "mIU/ml"
        case .estrogen: return "pg/ml"
        case .progesterone: return "ng/ml"
        case .e3g: return "ng/ml"
        case .pdg: return "µg/ml"
        case .testosterone: return "ng/dl"
        case .bbt: return "°F"
        }
    }
    
    func getValue(from reading: HormoneReading) -> Float? {
        switch self {
        case .lh: return reading.lhLevel
        case .fsh: return reading.fshLevel
        case .estrogen: return reading.estrogenLevel
        case .progesterone: return reading.progesteroneLevel
        case .e3g: return reading.e3gLevel
        case .pdg: return reading.pdgLevel
        case .testosterone: return reading.testosteroneLevel
        case .bbt: return reading.bbt
        }
    }
}

// MARK: - Time Range Selector
struct TimeRangeSelector: View {
    @Binding var selectedRange: TimeRange
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Range")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Button(action: {
                            selectedRange = range
                        }) {
                            Text(range.displayName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    selectedRange == range ? Color.pink : Color(.systemGray5)
                                )
                                .foregroundColor(
                                    selectedRange == range ? .white : .primary
                                )
                                .cornerRadius(20)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Hormone Selection Card
struct HormoneSelectionCard: View {
    @Binding var selectedHormones: Set<HormoneType>
    @Binding var showingSelection: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Selected Hormones")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Edit") {
                    showingSelection = true
                }
                .foregroundColor(.pink)
                .font(.subheadline)
                .fontWeight(.medium)
            }
            
            if selectedHormones.isEmpty {
                Text("No hormones selected")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(Array(selectedHormones).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { hormone in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(hormone.color)
                                .frame(width: 12, height: 12)
                            
                            Text(hormone.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Spacer()
                        }
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

// MARK: - Main Hormone Chart Card
struct HormoneChartCard: View {
    let readings: [HormoneReading]
    let selectedHormones: Set<HormoneType>
    let cycleData: [CycleData]
    let timeRange: TimeRange
    
    @State private var selectedDate: Date?
    
    var chartData: [(date: Date, hormone: HormoneType, value: Float)] {
        var data: [(date: Date, hormone: HormoneType, value: Float)] = []
        
        for reading in readings {
            for hormone in selectedHormones {
                if let value = hormone.getValue(from: reading) {
                    data.append((date: reading.date, hormone: hormone, value: value))
                }
            }
        }
        
        return data.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hormone Trends")
                .font(.headline)
                .fontWeight(.semibold)
            
            if chartData.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title)
                        .foregroundColor(.secondary)
                    
                    Text("No data for selected hormones")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(chartData, id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Level", dataPoint.value)
                        )
                        .foregroundStyle(dataPoint.hormone.color)
                        .symbol(Circle().strokeBorder(lineWidth: 2))
                        .symbolSize(30)
                        
                        AreaMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Level", dataPoint.value)
                        )
                        .foregroundStyle(
                            .linearGradient(
                                colors: [dataPoint.hormone.color.opacity(0.3), dataPoint.hormone.color.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                    
                    // Add cycle phase backgrounds
                    ForEach(cycleData.prefix(3), id: \.cycleStart) { cycle in
                        if let cycleEnd = cycle.cycleEnd {
                            RectangleMark(
                                xStart: .value("Start", cycle.cycleStart),
                                xEnd: .value("End", cycleEnd),
                                yStart: .value("Min", 0),
                                yEnd: .value("Max", maxYValue)
                            )
                            .foregroundStyle(.pink.opacity(0.1))
                        }
                    }
                }
                .frame(height: 300)
                .chartXAxis {
                    AxisMarks(values: .stride(by: timeRange == .lastWeek ? .day : .weekOfYear)) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                    }
                }
                .chartYAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartLegend(position: .bottom, alignment: .center) {
                    HStack(spacing: 16) {
                        ForEach(Array(selectedHormones).sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { hormone in
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(hormone.color)
                                    .frame(width: 8, height: 8)
                                Text(hormone.rawValue)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var maxYValue: Float {
        chartData.map(\.value).max() ?? 100
    }
}

// MARK: - No Data Chart Card
struct NoDataChartCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Chart Data")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Log some hormone tests to see your trends here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Chart Summary Card
struct ChartSummaryCard: View {
    let readings: [HormoneReading]
    let selectedHormones: Set<HormoneType>
    let timeRange: TimeRange
    
    var summaryStats: [(hormone: HormoneType, avg: Float, min: Float, max: Float)] {
        var stats: [(hormone: HormoneType, avg: Float, min: Float, max: Float)] = []
        
        for hormone in selectedHormones {
            let values = readings.compactMap { hormone.getValue(from: $0) }
            if !values.isEmpty {
                let avg = values.reduce(0, +) / Float(values.count)
                let min = values.min() ?? 0
                let max = values.max() ?? 0
                stats.append((hormone: hormone, avg: avg, min: min, max: max))
            }
        }
        
        return stats.sorted { $0.hormone.rawValue < $1.hormone.rawValue }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Summary Statistics")
                .font(.headline)
                .fontWeight(.semibold)
            
            if summaryStats.isEmpty {
                Text("No statistics available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 12) {
                    ForEach(summaryStats, id: \.hormone) { stat in
                        HormoneSummaryRow(
                            hormone: stat.hormone,
                            average: stat.avg,
                            minimum: stat.min,
                            maximum: stat.max
                        )
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

// MARK: - Hormone Summary Row
struct HormoneSummaryRow: View {
    let hormone: HormoneType
    let average: Float
    let minimum: Float
    let maximum: Float
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(hormone.color)
                    .frame(width: 12, height: 12)
                
                Text(hormone.rawValue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                StatItem(label: "Avg", value: average, unit: hormone.unit)
                StatItem(label: "Min", value: minimum, unit: hormone.unit)
                StatItem(label: "Max", value: maximum, unit: hormone.unit)
                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}

struct StatItem: View {
    let label: String
    let value: Float
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(String(format: "%.1f", value))
                .font(.caption)
                .fontWeight(.medium)
            
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Hormone Selection Sheet
struct HormoneSelectionSheet: View {
    @Binding var selectedHormones: Set<HormoneType>
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Select Hormones to Display") {
                    ForEach(HormoneType.allCases, id: \.self) { hormone in
                        HStack {
                            Circle()
                                .fill(hormone.color)
                                .frame(width: 16, height: 16)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(hormone.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Text(hormone.unit)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedHormones.contains(hormone) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.pink)
                                    .fontWeight(.semibold)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedHormones.contains(hormone) {
                                selectedHormones.remove(hormone)
                            } else {
                                selectedHormones.insert(hormone)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Hormones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.pink)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    ChartsView()
        .modelContainer(for: [HormoneReading.self, SymptomLog.self, CycleData.self], inMemory: true)
}