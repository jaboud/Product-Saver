//
//  AppearanceSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/3/2024.
//

import SwiftUI


struct AppearanceSettingsView: View {

    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ScaledMetric var iconSize: CGFloat = 1

    var body: some View {
        NavigationStack {
            List {
                Section{
                    NavigationLink(destination: SchemeSettingsView(settingsViewModel: settingsViewModel)) {
                        HStack {
                            Label("Scheme", systemImage: "rays").labelStyle(SettingsIconStyle(color: settingsViewModel.tintColors == .blue ? .blue : settingsViewModel.tintColors, size: iconSize))
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
                        HStack {
                            Label("Tint Color", systemImage: "paintbrush.fill").labelStyle(SettingsIconStyle(color: settingsViewModel.tintColors == .blue ? .orange : settingsViewModel.tintColors, size: iconSize))
                            Spacer()
                            Text({
                                switch settingsViewModel.tintColor {
                                case 0:
                                    return "Default"
                                case 1:
                                    return "Green"
                                case 2:
                                    return "Red"
                                case 3:
                                    return "Orange"
                                case 4:
                                    return "Pink"
                                case 5:
                                    return "Purple"
                                default:
                                    return "Unknown"
                                }
                            }())
                            .foregroundStyle(.gray)
                        }
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
