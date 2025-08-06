//
//  ContentView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [HormoneReading.self, SymptomLog.self, CycleData.self], inMemory: true)
}
