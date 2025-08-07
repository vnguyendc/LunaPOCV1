//
//  SharedComponents.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI

// MARK: - Hormone Level Enum
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

// MARK: - Trend Enum
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

// MARK: - Hormone Row View (for HomeView with trend)
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

// MARK: - Simple Hormone Row View (for DayDetailView without trend)
struct SimpleHormoneRowView: View {
    let name: String
    let value: String
    let level: HormoneLevel
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.medium)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(value)
                    .fontWeight(.semibold)
                
                Circle()
                    .fill(level.color)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 2)
    }
}