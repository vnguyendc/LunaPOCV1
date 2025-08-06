//
//  ProfileView.swift
//  Luna
//
//  Created by VinhNguyen on 8/2/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Profile View")
                    .font(.title2)
                Text("Coming Soon")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}