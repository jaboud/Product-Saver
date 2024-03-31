//
//  SchemeSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 18/3/2024.
//

import SwiftUI

struct SchemeSettingsView: View {

    @ObservedObject var settingsViewModel: Settings
    
    var body: some View {
        NavigationStack {
            List {
                Section(footer: Text("The selected scheme will be applied throughout the entire app"))
                {
                    Picker("", selection: $settingsViewModel.colorSchemeOption) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Scheme")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SchemeSettingsView(settingsViewModel: Settings())
}
