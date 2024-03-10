//
//  ContentSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/3/2024.
//

import SwiftUI

struct ContentSettingsView: View {
    @ObservedObject var settingsViewModel: SettingsViewModel
    var body: some View {
        NavigationStack {
            List {
                Section(footer: Text("When enabled, categories will be grouped together with the list of products. Filtering Categories will be disabled when this option is enabled.")) {
                    Toggle(isOn: $settingsViewModel.isGroupingCategories) {
                        Text("Group Categories")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.tintColors == .blue ? .green : settingsViewModel.tintColors))
                }
                Section(footer: Text("When enabled, blank data will be hidden within Product Details.")) {
                    Toggle(isOn: $settingsViewModel.isHidingBlankData) {
                        Text("Hide Blank Data")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.tintColors == .blue ? .green : settingsViewModel.tintColors))
                }
            }
            .navigationTitle("Content")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentSettingsView(settingsViewModel: SettingsViewModel())
}
