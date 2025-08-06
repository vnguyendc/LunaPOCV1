//
//  MockDataService.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import Foundation
import SwiftData

class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    // MARK: - Mock Data Generation
    
    func generateMockData(in modelContext: ModelContext) {
        // Clear existing data
        clearExistingData(in: modelContext)
        
        // Generate data for the last 3 months
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -3, to: endDate) ?? endDate
        
        generateHormoneReadings(from: startDate, to: endDate, in: modelContext)
        generateSymptomLogs(from: startDate, to: endDate, in: modelContext)
        generateCycleData(from: startDate, to: endDate, in: modelContext)
        
        do {
            try modelContext.save()
            print("✅ Mock data generated successfully")
        } catch {
            print("❌ Failed to save mock data: \(error)")
        }
    }
    
    private func clearExistingData(in modelContext: ModelContext) {
        do {
            try modelContext.delete(model: HormoneReading.self)
            try modelContext.delete(model: SymptomLog.self)
            try modelContext.delete(model: CycleData.self)
        } catch {
            print("Failed to clear existing data: \(error)")
        }
    }
    
    // MARK: - Hormone Readings Generation
    
    private func generateHormoneReadings(from startDate: Date, to endDate: Date, in modelContext: ModelContext) {
        let calendar = Calendar.current
        var currentDate = startDate
        
        // Simulate 3 complete cycles
        let cycleStarts = [
            calendar.date(byAdding: .day, value: 0, to: startDate)!,
            calendar.date(byAdding: .day, value: 28, to: startDate)!,
            calendar.date(byAdding: .day, value: 58, to: startDate)!
        ]
        
        for cycleStart in cycleStarts {
            generateCycleHormoneReadings(cycleStart: cycleStart, in: modelContext)
        }
    }
    
    private func generateCycleHormoneReadings(cycleStart: Date, in modelContext: ModelContext) {
        let calendar = Calendar.current
        
        for day in 0..<32 { // 32-day cycle
            guard let date = calendar.date(byAdding: .day, value: day, to: cycleStart) else { continue }
            
            let cycleDay = day + 1
            let (lh, fsh, estrogen, progesterone) = generateHormoneValuesForCycleDay(cycleDay)
            
            let reading = HormoneReading(
                date: date,
                lhLevel: lh,
                fshLevel: fsh,
                estrogenLevel: estrogen,
                progesteroneLevel: progesterone,
                bbt: generateBBT(cycleDay: cycleDay),
                deviceId: "Mira Monitor",
                confidenceScore: Float.random(in: 0.75...0.95)
            )
            
            modelContext.insert(reading)
        }
    }
    
    private func generateHormoneValuesForCycleDay(_ cycleDay: Int) -> (Float, Float, Float, Float) {
        switch cycleDay {
        case 1...5: // Menstrual phase
            return (
                Float.random(in: 2...8),    // LH low
                Float.random(in: 3...10),   // FSH moderate
                Float.random(in: 30...80),  // Estrogen low
                Float.random(in: 0.2...1.0) // Progesterone low
            )
        case 6...13: // Follicular phase
            let estrogenMultiplier = Float(cycleDay - 5) * 0.3
            return (
                Float.random(in: 5...15),   // LH rising
                Float.random(in: 5...12),   // FSH rising
                Float.random(in: 80...200) * (1 + estrogenMultiplier), // Estrogen rising
                Float.random(in: 0.3...1.2) // Progesterone still low
            )
        case 14...16: // Ovulation (LH surge)
            return (
                Float.random(in: 20...45),  // LH surge
                Float.random(in: 8...15),   // FSH peak
                Float.random(in: 150...300), // Estrogen peak
                Float.random(in: 0.5...2.0) // Progesterone starting to rise
            )
        case 17...28: // Luteal phase
            let progesteroneDay = cycleDay - 16
            let progesteroneLevel = min(Float.random(in: 5...20), Float(progesteroneDay) * 1.5 + 2)
            return (
                Float.random(in: 3...10),   // LH back to baseline
                Float.random(in: 2...8),    // FSH back to baseline
                Float.random(in: 80...150), // Estrogen declining
                progesteroneLevel           // Progesterone high
            )
        default: // Late luteal/pre-menstrual
            return (
                Float.random(in: 2...6),    // LH low
                Float.random(in: 2...6),    // FSH low
                Float.random(in: 40...100), // Estrogen dropping
                Float.random(in: 1...5)     // Progesterone dropping
            )
        }
    }
    
    private func generateBBT(cycleDay: Int) -> Float {
        let baseBBT: Float = 97.2
        
        if cycleDay < 14 {
            // Pre-ovulation - lower temperature
            return baseBBT + Float.random(in: -0.3...0.2)
        } else {
            // Post-ovulation - higher temperature
            return baseBBT + Float.random(in: 0.3...0.8)
        }
    }
    
    // MARK: - Symptom Logs Generation
    
    private func generateSymptomLogs(from startDate: Date, to endDate: Date, in modelContext: ModelContext) {
        let calendar = Calendar.current
        var currentDate = startDate
        
        while currentDate <= endDate {
            // Generate symptoms for about 60% of days (realistic usage)
            if Bool.random() && Double.random(in: 0...1) < 0.6 {
                let symptomLog = generateSymptomLogForDate(currentDate)
                modelContext.insert(symptomLog)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? endDate
        }
    }
    
    private func generateSymptomLogForDate(_ date: Date) -> SymptomLog {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        
        // Simulate period days (roughly days 1-5 of each cycle)
        let periodFlow: PeriodFlow = {
            let cycleDay = dayOfMonth % 28 + 1
            switch cycleDay {
            case 1...2: return [.medium, .heavy].randomElement()!
            case 3...4: return [.light, .medium].randomElement()!
            case 5: return .light
            default: return .none
            }
        }()
        
        let moodScore = Int.random(in: 3...9)
        let acneLevel: AcneLevel = [.none, .mild, .moderate].randomElement()!
        let bodyHair: BodyHairLevel = [.noChange, .increased, .decreased].randomElement()!
        let weight = Float.random(in: 135...145)
        
        let notes = generateRandomNotes()
        
        return SymptomLog(
            date: date,
            periodFlow: periodFlow,
            moodScore: moodScore,
            acneLevel: acneLevel,
            bodyHair: bodyHair,
            weight: weight,
            notes: notes
        )
    }
    
    private func generateRandomNotes() -> String? {
        let notes = [
            "Feeling energetic today",
            "Had some cramping",
            "Mood was great",
            "Felt a bit tired",
            "Had a good workout",
            "Craving sweets",
            "Skin looking clear",
            "Feeling bloated",
            nil, nil, nil // More likely to have no notes
        ]
        
        return notes.randomElement() ?? nil
    }
    
    // MARK: - Cycle Data Generation
    
    private func generateCycleData(from startDate: Date, to endDate: Date, in modelContext: ModelContext) {
        let calendar = Calendar.current
        
        // Generate 3 complete cycles
        let cycleLengths = [28, 32, 29] // Varying cycle lengths
        var currentStart = startDate
        
        for (index, cycleLength) in cycleLengths.enumerated() {
            let cycleEnd = calendar.date(byAdding: .day, value: cycleLength - 1, to: currentStart)!
            let ovulationDate = calendar.date(byAdding: .day, value: cycleLength / 2, to: currentStart)!
            
            let cycle = CycleData(
                cycleStart: currentStart,
                cycleEnd: cycleEnd,
                ovulationDate: ovulationDate,
                cycleLength: cycleLength,
                lutealPhaseLength: cycleLength - (cycleLength / 2),
                isAnovulatory: false,
                confidence: Float.random(in: 0.8...0.95),
                predictedOvulation: calendar.date(byAdding: .day, value: -1, to: ovulationDate),
                predictedNextPeriod: calendar.date(byAdding: .day, value: cycleLength, to: currentStart)
            )
            
            modelContext.insert(cycle)
            
            // Move to next cycle
            currentStart = calendar.date(byAdding: .day, value: cycleLength, to: currentStart) ?? endDate
        }
        
        // Add current incomplete cycle
        if currentStart <= endDate {
            let predictedOvulation = calendar.date(byAdding: .day, value: 3, to: Date()) // Predict ovulation in 3 days
            let predictedNextPeriod = calendar.date(byAdding: .day, value: 18, to: Date()) // Predict next period
            
            let currentCycle = CycleData(
                cycleStart: currentStart,
                cycleEnd: nil, // Current cycle not ended
                ovulationDate: nil, // Not yet ovulated
                cycleLength: nil,
                lutealPhaseLength: nil,
                isAnovulatory: false,
                confidence: 0.87,
                predictedOvulation: predictedOvulation,
                predictedNextPeriod: predictedNextPeriod
            )
            
            modelContext.insert(currentCycle)
        }
    }
}