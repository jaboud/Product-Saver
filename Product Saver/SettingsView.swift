//
//  SettingsView.swift
//  Producg Saver
//
//  Created by Justin Aboud on 22/1/2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {

    @ObservedObject var settingsViewModel: Settings
    @ScaledMetric var iconSize: CGFloat = 1

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: AppearanceSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Appearance", systemImage: "paintbrush.fill").labelStyle(SettingsIconStyle(color: settingsViewModel.tintColors == .blue ? .purple : settingsViewModel.tintColors, size: iconSize))
                    }
                }
                Section {
                    NavigationLink(destination: ContentSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Content", systemImage: "list.bullet.rectangle.fill").labelStyle(SettingsIconStyle(color: settingsViewModel.tintColors == .blue ? .gray : settingsViewModel.tintColors, size: iconSize))
                    }
                }
                Section {
                    NavigationLink(destination: DataSettingsView(settingsViewModel: settingsViewModel)) {
                        Label("Data", systemImage: "externaldrive.fill").labelStyle(SettingsIconStyle(color: settingsViewModel.tintColors == .blue ? .red : settingsViewModel.tintColors, size: iconSize))
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
    SettingsView(settingsViewModel: Settings())
}
