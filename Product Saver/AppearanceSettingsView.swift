//
//  AppearanceSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/3/2024.
//

import SwiftUI


struct AppearanceSettingsView: View {

    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var settings: Settings
    @ScaledMetric var iconSize: CGFloat = 1

    var body: some View {
        NavigationStack {
            List {
                Section{
                    NavigationLink(destination: SchemeSettingsView(settings: settings)) {
                        HStack {
                            Label("Scheme", systemImage: "rays").labelStyle(SettingsIconStyle(color: settings.tintColors == .blue ? .blue : settings.tintColors, size: iconSize))
                            Spacer()
                            Text({
                                switch settings.colorSchemeOption {
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
                    NavigationLink(destination: TintColorSettingsView(settings: settings)) {
                        HStack {
                            Label("Tint Color", systemImage: "paintbrush.fill").labelStyle(SettingsIconStyle(color: settings.tintColors == .blue ? .orange : settings.tintColors, size: iconSize))
                            Spacer()
                            Text({
                                switch settings.tintColor {
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
    AppearanceSettingsView(settings: Settings())
}
