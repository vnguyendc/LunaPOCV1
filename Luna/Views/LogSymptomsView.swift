//
//  LogSymptomsView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI
import SwiftData

struct LogSymptomsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var symptomDate = Date()
    @State private var periodFlow: PeriodFlow = .none
    @State private var moodScore = 5
    @State private var acneLevel: AcneLevel = .none
    @State private var bodyHair: BodyHairLevel = .noChange
    @State private var weight: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        Form {
                Section("Date") {
                    DatePicker("Symptom Date", selection: $symptomDate, displayedComponents: .date)
                }
                
                Section("Physical Symptoms") {
                    Picker("Period Flow", selection: $periodFlow) {
                        ForEach(PeriodFlow.allCases, id: \.self) { flow in
                            Text(flow.rawValue).tag(flow)
                        }
                    }
                    
                    Picker("Acne Level", selection: $acneLevel) {
                        ForEach(AcneLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    
                    Picker("Body Hair", selection: $bodyHair) {
                        ForEach(BodyHairLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    
                    HStack {
                        Text("Weight")
                        Spacer()
                        TextField("0.0", text: $weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("lbs")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Emotional Wellbeing") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Mood Score")
                            Spacer()
                            Text("\(moodScore)/10")
                                .fontWeight(.medium)
                        }
                        
                        Slider(value: Binding(
                            get: { Double(moodScore) },
                            set: { moodScore = Int($0) }
                        ), in: 1...10, step: 1)
                        
                        HStack {
                            Text("Poor")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("Excellent")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("How are you feeling today?", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
        }
        .navigationTitle("Log Symptoms")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.pink)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveSymptomLog()
                }
                .fontWeight(.semibold)
            }
        }
    }
    
    private func saveSymptomLog() {
        let symptomLog = SymptomLog(
            date: symptomDate,
            periodFlow: periodFlow,
            moodScore: moodScore,
            acneLevel: acneLevel,
            bodyHair: bodyHair,
            weight: Float(weight),
            notes: notes.isEmpty ? nil : notes
        )
        
        modelContext.insert(symptomLog)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save symptom log: \(error)")
        }
    }
}

#Preview {
    LogSymptomsView()
        .modelContainer(for: [SymptomLog.self], inMemory: true)
}