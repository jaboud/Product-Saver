//
//  ContentSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/3/2024.
//

import SwiftUI

struct ContentSettingsView: View {

    @ObservedObject var settings: Settings
    
    var body: some View {
        NavigationStack {
            List {
                Section(footer: Text("Group categories together with the list of products. Filtering Categories will be disabled when this option is enabled.")) {
                    Toggle(isOn: $settings.isGroupingCategories) {
                        Text("Group Categories")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: settings.tintColors == .blue ? .green : settings.tintColors))
                }
                Section(footer: Text("Hide empty product data within Product Details.")) {
                    Toggle(isOn: $settings.isHidingEmptyProductData) {
                        Text("Hide Empty Product Data")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: settings.tintColors == .blue ? .green : settings.tintColors))
                }
            }
            .navigationTitle("Content")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentSettingsView(settings: Settings())
}
