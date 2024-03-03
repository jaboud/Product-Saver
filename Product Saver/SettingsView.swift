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

                Section(header: Label("About", systemImage: "info.circle")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown")")
                            .font(.body)
                            .padding(.bottom, 5)
                        Divider()
                        Text("Developed by: Justin Aboud")
                            .font(.body)
                            .padding(.bottom, 5)
                        Divider()
                        Text("Contact: ")
                            .font(.body)
                            + Text("justin.aboud@icloud.com")
                            .foregroundColor(settingsViewModel.tintColors)
                            .font(.body)

                    }
                }
            }
            .navigationTitle("Settings")
            .accentColor(settingsViewModel.tintColors)
        }
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel())
}
