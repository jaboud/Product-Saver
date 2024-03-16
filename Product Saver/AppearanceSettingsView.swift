//
//  AppearanceSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/3/2024.
//

import SwiftUI


struct AppearanceSettingsView: View {

    @ObservedObject var settingsViewModel: SettingsViewModel

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Scheme"))
                {
                    Picker("", selection: $settingsViewModel.colorSchemeOption) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }

                Section{
                    NavigationLink(destination: TintColorSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Tint Color", systemImage: "paintpalette")
                    }
                }
            }
            .navigationTitle("Appearance")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AppearanceSettingsView(settingsViewModel: SettingsViewModel())
}
