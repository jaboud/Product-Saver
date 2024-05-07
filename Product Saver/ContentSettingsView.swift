//
//  ContentSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/3/2024.
//

import SwiftUI

struct ContentSettingsView: View {

    @ObservedObject var settings: Settings
    @ScaledMetric var iconSize: CGFloat = 1

    var body: some View {
        NavigationStack {
            List {
                Section(footer: Text("Group products together, arranging them alphabetically either by item or brand name. This option enables the choice between 'Item' or 'Brand' for the grouping criteria.")) {
                    Toggle(isOn: $settings.isGroupingProducts) {
                        Text("Group Products")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: settings.tintColors == .blue ? .green : settings.tintColors))
                    .disabled(settings.isGroupingCategories)
                    if settings.isGroupingProducts {
                        NavigationLink(destination: GroupProductsSettingsView(settings: settings)) {
                            HStack {
                                Text("Group Prouduct by")
                                Spacer()
                                Text(settings.groupProductBy)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
                Section(footer: Text("Group categories together with the list of products. Filtering Categories will be disabled when this option is enabled.")) {
                    Toggle(isOn: $settings.isGroupingCategories) {
                        Text("Group Categories")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: settings.tintColors == .blue ? .green : settings.tintColors))
                    .disabled(settings.isGroupingProducts)
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
    let settings = Settings()
    settings.isGroupingCategories = false
    return ContentSettingsView(settings: settings)
}
