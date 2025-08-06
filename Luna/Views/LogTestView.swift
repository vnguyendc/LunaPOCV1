//
//  LogTestView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI
import SwiftData

struct LogTestView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var testDate = Date()
    @State private var lhLevel: String = ""
    @State private var fshLevel: String = ""
    @State private var estrogenLevel: String = ""
    @State private var progesteroneLevel: String = ""
    @State private var bbt: String = ""
    @State private var notes: String = ""
    @State private var selectedDevice = "Manual Entry"
    
    private let devices = ["Manual Entry", "Mira Monitor", "Oova Kit", "Proov Test"]
    
    var body: some View {
        Form {
                Section("Test Details") {
                    DatePicker("Date & Time", selection: $testDate)
                    
                    Picker("Device", selection: $selectedDevice) {
                        ForEach(devices, id: \.self) { device in
                            Text(device).tag(device)
                        }
                    }
                }
                
                Section("Hormone Levels") {
                    HormoneInputRow(title: "LH", value: $lhLevel, unit: "mIU/ml")
                    HormoneInputRow(title: "FSH", value: $fshLevel, unit: "mIU/ml")
                    HormoneInputRow(title: "Estrogen", value: $estrogenLevel, unit: "pg/ml")
                    HormoneInputRow(title: "Progesterone", value: $progesteroneLevel, unit: "ng/ml")
                    HormoneInputRow(title: "BBT", value: $bbt, unit: "°F")
                }
                
                Section("Notes") {
                    TextField("Additional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
        }
        .navigationTitle("Record Test Results")
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
                    saveHormoneReading()
                }
                .fontWeight(.semibold)
            }
        }
    }
    
    private func saveHormoneReading() {
        let reading = HormoneReading(
            date: testDate,
            lhLevel: Float(lhLevel),
            fshLevel: Float(fshLevel),
            estrogenLevel: Float(estrogenLevel),
            progesteroneLevel: Float(progesteroneLevel),
            bbt: Float(bbt),
            deviceId: selectedDevice == "Manual Entry" ? nil : selectedDevice,
            notes: notes.isEmpty ? nil : notes
        )
        
        modelContext.insert(reading)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save hormone reading: \(error)")
        }
    }
}

// MARK: - Hormone Input Row
struct HormoneInputRow: View {
    let title: String
    @Binding var value: String
    let unit: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            
            Spacer()
            
            TextField("0.0", text: $value)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
            
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 50, alignment: .leading)
        }
    }
}

#Preview {
    LogTestView()
        .modelContainer(for: [HormoneReading.self], inMemory: true)
}