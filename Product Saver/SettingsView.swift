//
//  SettingsView.swift
//  Producg Saver
//
//  Created by Justin Aboud on 22/1/2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {

    @ObservedObject var settingsViewModel: SettingsViewModel

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: AppearanceSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Appearance", systemImage: "paintbrush")
                    }
                }
                Section {
                    NavigationLink(destination: ContentSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Content", systemImage: "list.bullet.rectangle")
                    }
                }
                Section {
                    NavigationLink(destination: DataSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Data", systemImage: "externaldrive")
                    }
                }

                AboutSectionView()

                ContactDeveloperSectionView(settingsViewModel: settingsViewModel)
            }
            .navigationTitle("Settings")
            .accentColor(settingsViewModel.tintColors)
        }
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel())
}
