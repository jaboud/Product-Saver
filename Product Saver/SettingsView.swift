//
//  SettingsView.swift
//  Producg Saver
//
//  Created by Justin Aboud on 22/1/2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {

    @ObservedObject var settings: Settings
    @ScaledMetric var iconSize: CGFloat = 1

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: AppearanceSettingsView(settings: settings)) {
                        Label("Appearance", systemImage: "paintbrush.fill").labelStyle(SettingsIconStyle(color: settings.tintColors == .blue ? .purple : settings.tintColors, size: iconSize))
                    }
                }
                Section {
                    NavigationLink(destination: ContentSettingsView(settings: settings)) {
                        Label("Content", systemImage: "list.bullet.rectangle.fill").labelStyle(SettingsIconStyle(color: settings.tintColors == .blue ? .gray : settings.tintColors, size: iconSize))
                    }
                }
                Section {
                    NavigationLink(destination: DataSettingsView(settings: settings)) {
                        Label("Data", systemImage: "externaldrive.fill").labelStyle(SettingsIconStyle(color: settings.tintColors == .blue ? .red : settings.tintColors, size: iconSize))
                    }
                }

                AboutView()

                ContactDeveloperView(settings: settings)
            }
            .navigationTitle("Settings")
            .accentColor(settings.tintColors)
        }
    }
}

#Preview {
    SettingsView(settings: Settings())
}
