//
//  DataModels.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import Foundation
import SwiftData

// MARK: - Hormone Reading Model
@Model
final class HormoneReading {
    var date: Date
    var lhLevel: Float?           // LH in mIU/ml
    var fshLevel: Float?          // FSH in mIU/ml
    var estrogenLevel: Float?     // Estrogen in pg/ml
    var progesteroneLevel: Float? // Progesterone in ng/ml
    var e3gLevel: Float?          // E3G in ng/ml
    var pdgLevel: Float?          // PdG in µg/ml
    var testosteroneLevel: Float? // Testosterone in ng/dl
    var bbt: Float?               // Basal Body Temperature in °F
    var deviceId: String?         // Connected device identifier
    var confidenceScore: Float    // Algorithm confidence (0.0-1.0)
    var notes: String?
    
    init(date: Date, lhLevel: Float? = nil, fshLevel: Float? = nil, 
         estrogenLevel: Float? = nil, progesteroneLevel: Float? = nil,
         e3gLevel: Float? = nil, pdgLevel: Float? = nil, 
         testosteroneLevel: Float? = nil, bbt: Float? = nil,
         deviceId: String? = nil, confidenceScore: Float = 0.8, notes: String? = nil) {
        self.date = date
        self.lhLevel = lhLevel
        self.fshLevel = fshLevel
        self.estrogenLevel = estrogenLevel
        self.progesteroneLevel = progesteroneLevel
        self.e3gLevel = e3gLevel
        self.pdgLevel = pdgLevel
        self.testosteroneLevel = testosteroneLevel
        self.bbt = bbt
        self.deviceId = deviceId
        self.confidenceScore = confidenceScore
        self.notes = notes
    }
}

// MARK: - Symptom Log Model
@Model
final class SymptomLog {
    var date: Date
    var periodFlow: PeriodFlow
    var moodScore: Int            // 1-10 scale
    var acneLevel: AcneLevel
    var bodyHair: BodyHairLevel
    var weight: Float?            // in lbs
    var notes: String?
    var customSymptoms: [String: String] // Key-value pairs for custom tracking
    
    init(date: Date, periodFlow: PeriodFlow = .none, moodScore: Int = 5,
         acneLevel: AcneLevel = .none, bodyHair: BodyHairLevel = .noChange,
         weight: Float? = nil, notes: String? = nil, customSymptoms: [String: String] = [:]) {
        self.date = date
        self.periodFlow = periodFlow
        self.moodScore = moodScore
        self.acneLevel = acneLevel
        self.bodyHair = bodyHair
        self.weight = weight
        self.notes = notes
        self.customSymptoms = customSymptoms
    }
}

// MARK: - Cycle Data Model
@Model
final class CycleData {
    var cycleStart: Date
    var cycleEnd: Date?
    var ovulationDate: Date?
    var cycleLength: Int?
    var lutealPhaseLength: Int?
    var isAnovulatory: Bool
    var confidence: Float         // Algorithm confidence (0.0-1.0)
    var predictedOvulation: Date?
    var predictedNextPeriod: Date?
    
    init(cycleStart: Date, cycleEnd: Date? = nil, ovulationDate: Date? = nil,
         cycleLength: Int? = nil, lutealPhaseLength: Int? = nil,
         isAnovulatory: Bool = false, confidence: Float = 0.7,
         predictedOvulation: Date? = nil, predictedNextPeriod: Date? = nil) {
        self.cycleStart = cycleStart
        self.cycleEnd = cycleEnd
        self.ovulationDate = ovulationDate
        self.cycleLength = cycleLength
        self.lutealPhaseLength = lutealPhaseLength
        self.isAnovulatory = isAnovulatory
        self.confidence = confidence
        self.predictedOvulation = predictedOvulation
        self.predictedNextPeriod = predictedNextPeriod
    }
}

// MARK: - Enums
enum PeriodFlow: String, CaseIterable, Codable {
    case none = "None"
    case light = "Light"
    case medium = "Medium"
    case heavy = "Heavy"
    case veryHeavy = "Very Heavy"
}

enum AcneLevel: String, CaseIterable, Codable {
    case none = "None"
    case mild = "Mild"
    case moderate = "Moderate"
    case severe = "Severe"
}

enum BodyHairLevel: String, CaseIterable, Codable {
    case noChange = "No Change"
    case increased = "Increased"
    case decreased = "Decreased"
}
