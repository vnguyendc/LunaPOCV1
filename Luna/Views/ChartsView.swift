//
//  ChartsView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI

struct ChartsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Charts View")
                    .font(.title2)
                Text("Coming Soon")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Charts")
        }
    }
}

#Preview {
    ChartsView()
}