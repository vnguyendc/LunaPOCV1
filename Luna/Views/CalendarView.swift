//
//  CalendarView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Calendar View")
                    .font(.title2)
                Text("Coming Soon")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Calendar")
        }
    }
}

#Preview {
    CalendarView()
}