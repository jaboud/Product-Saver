//
//  TintColorSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/3/2024.
//

import SwiftUI

struct TintColorSettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            List{
                Section(footer: Text("Some options may be hidden based on the selected color scheme.")) {
                    Picker("Tint Color", selection: $settingsViewModel.tintColor) {
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                            Text("Default")
                        }
                        .tag(0)
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.green)
                            Text("Green")
                        }
                        .tag(1)
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.red)
                            Text("Red")
                        }
                        .tag(2)
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.orange)
                            Text("Orange")
                        }
                        .tag(3)
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.pink)
                            Text("Pink")
                        }
                        .tag(4)
                        HStack{
                            Image(systemName: "circle.fill")
                                .foregroundColor(.purple)
                            Text("Purple")
                        }
                        .tag(5)
                        if colorScheme == .dark {
                            HStack{
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.yellow)
                                Text("Yellow")
                            }
                            .tag(6)
                        }
                    }
                    .onChange(of: colorScheme) {
                        if colorScheme == .light {
                            settingsViewModel.tintColor = 0
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Tint Color")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    TintColorSettingsView(settingsViewModel: SettingsViewModel())
}
