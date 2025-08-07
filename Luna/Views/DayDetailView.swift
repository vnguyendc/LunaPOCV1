//
//  DayDetailView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI
import SwiftData

struct DayDetailView: View {
    let selectedDate: Date
    let hormoneReadings: [HormoneReading]
    let symptomLogs: [SymptomLog]
    let cycleData: [CycleData]
    
    @Environment(\.dismiss) private var dismiss
    private let calendar = Calendar.current
    
    private var dayHormoneReading: HormoneReading? {
        hormoneReadings.first { reading in
            calendar.isDate(reading.date, inSameDayAs: selectedDate)
        }
    }
    
    private var daySymptomLog: SymptomLog? {
        symptomLogs.first { log in
            calendar.isDate(log.date, inSameDayAs: selectedDate)
        }
    }
    
    private var cycleInfo: (phase: CyclePhase, day: Int)? {
        guard let cycle = cycleData.first(where: { cycle in
            let cycleStart = calendar.startOfDay(for: cycle.cycleStart)
            let cycleEnd = cycle.cycleEnd.map { calendar.startOfDay(for: $0) } ?? Date()
            let dayStart = calendar.startOfDay(for: selectedDate)
            return dayStart >= cycleStart && dayStart <= cycleEnd
        }) else {
            return nil
        }
        
        let daysSinceStart = calendar.dateComponents([.day], from: cycle.cycleStart, to: selectedDate).day ?? 0
        let cycleDay = daysSinceStart + 1
        
        let phase: CyclePhase
        if daysSinceStart <= 5 {
            phase = .menstrual
        } else if daysSinceStart <= 13 {
            phase = .follicular
        } else if daysSinceStart <= 16 {
            phase = .ovulatory
        } else {
            phase = .luteal
        }
        
        return (phase, cycleDay)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Date Header
                    DateHeaderCard(selectedDate: selectedDate)
                    
                    // Cycle Information
                    if let cycleInfo = cycleInfo {
                        CycleInfoCard(phase: cycleInfo.phase, day: cycleInfo.day)
                    }
                    
                    // Hormone Readings
                    if let reading = dayHormoneReading {
                        HormoneReadingCard(reading: reading)
                    } else {
                        NoDataCard(type: "Hormone Readings", icon: "drop.circle")
                    }
                    
                    // Symptoms
                    if let symptoms = daySymptomLog {
                        SymptomLogCard(symptoms: symptoms)
                    } else {
                        NoDataCard(type: "Symptoms", icon: "heart.circle")
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Day Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.pink)
                }
            }
        }
    }
}

// MARK: - Date Header Card
extension DayDetailView {
    struct DateHeaderCard: View {
        let selectedDate: Date
        
        var body: some View {
            VStack(spacing: 8) {
                Text(selectedDate, style: .date)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(selectedDate.formatted(.dateTime.weekday(.wide)))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

// MARK: - Cycle Info Card
struct CycleInfoCard: View {
    let phase: CyclePhase
    let day: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(phase.color)
                    .frame(width: 16, height: 16)
                
                Text("Cycle Information")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Phase:")
                        .fontWeight(.medium)
                    Spacer()
                    Text(phase.name)
                        .foregroundColor(phase.color)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Cycle Day:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(day)")
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Hormone Reading Card
struct HormoneReadingCard: View {
    let reading: HormoneReading
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "drop.circle.fill")
                    .foregroundColor(.pink)
                    .font(.title2)
                
                Text("Hormone Readings")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                if let lh = reading.lhLevel {
                    SimpleHormoneRowView(name: "LH", value: String(format: "%.1f mIU/ml", lh), level: getHormoneLevel(lh, for: "LH"))
                }
                
                if let fsh = reading.fshLevel {
                    SimpleHormoneRowView(name: "FSH", value: String(format: "%.1f mIU/ml", fsh), level: getHormoneLevel(fsh, for: "FSH"))
                }
                
                if let estrogen = reading.estrogenLevel {
                    SimpleHormoneRowView(name: "Estrogen", value: String(format: "%.0f pg/ml", estrogen), level: getHormoneLevel(estrogen, for: "Estrogen"))
                }
                
                if let progesterone = reading.progesteroneLevel {
                    SimpleHormoneRowView(name: "Progesterone", value: String(format: "%.1f ng/ml", progesterone), level: getHormoneLevel(progesterone, for: "Progesterone"))
                }
                
                if let bbt = reading.bbt {
                    SimpleHormoneRowView(name: "BBT", value: String(format: "%.1f°F", bbt), level: .normal)
                }
            }
            
            if let notes = reading.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Notes:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func getHormoneLevel(_ value: Float, for hormone: String) -> HormoneLevel {
        // Simplified hormone level categorization
        switch hormone {
        case "LH":
            return value > 20 ? .high : value > 5 ? .normal : .low
        case "FSH":
            return value > 15 ? .high : value > 3 ? .normal : .low
        case "Estrogen":
            return value > 200 ? .high : value > 50 ? .normal : .low
        case "Progesterone":
            return value > 5 ? .high : value > 1 ? .normal : .low
        default:
            return .normal
        }
    }
}

// MARK: - Symptom Log Card
struct SymptomLogCard: View {
    let symptoms: SymptomLog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .foregroundColor(.pink)
                    .font(.title2)
                
                Text("Symptoms")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            VStack(spacing: 8) {
                if symptoms.periodFlow != .none {
                    SymptomRowView(name: "Period Flow", value: symptoms.periodFlow.rawValue.capitalized)
                }
                
                SymptomRowView(name: "Mood", value: "\(symptoms.moodScore)/10")
                
                if symptoms.acneLevel != .none {
                    SymptomRowView(name: "Acne", value: symptoms.acneLevel.rawValue.capitalized)
                }
                
                if symptoms.bodyHair != .noChange {
                    SymptomRowView(name: "Body Hair", value: symptoms.bodyHair.rawValue.capitalized)
                }
                
                if let weight = symptoms.weight {
                    SymptomRowView(name: "Weight", value: String(format: "%.1f lbs", weight))
                }
            }
            
            if let notes = symptoms.notes, !notes.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Notes:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - No Data Card
struct NoDataCard: View {
    let type: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.secondary)
            
            Text("No \(type)")
                .font(.headline)
                .fontWeight(.medium)
            
            Text("No data logged for this day")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Helper Views

struct SymptomRowView: View {
    let name: String
    let value: String
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}



#Preview {
    DayDetailView(
        selectedDate: Date(),
        hormoneReadings: [],
        symptomLogs: [],
        cycleData: []
    )
}