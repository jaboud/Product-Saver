//
//  AppearanceSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/3/2024.
//

import SwiftUI


struct AppearanceSettingsView: View {

    @ObservedObject var settingsViewModel: SettingsViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            List {
                Section{
                    NavigationLink(destination: SchemeSettingsView(settingsViewModel: settingsViewModel)) {
                        HStack {
                            Text("Scheme")
                            Spacer()
                            Text({
                                switch settingsViewModel.colorSchemeOption {
                                case 0:
                                    return "System"
                                case 1:
                                    return "Light"
                                case 2:
                                    return "Dark"
                                default:
                                    return "Unknown"
                                }
                            }())
                            .foregroundStyle(.gray)
                        }
                    }
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
