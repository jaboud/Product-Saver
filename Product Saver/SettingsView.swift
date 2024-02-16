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
    @Environment(\.modelContext) var context
    @Query private var categories: [Category]
    @Query private var storedDatas: [StoredData]
    @State private var showAllDataDeletionConfirmation = false
    @State private var showAllDataDeletionWarning = false
    @State private var showProductDataDeletionConfirmation = false
    @State private var showProductDataDeletionWarning = false
    @State private var categoryName: String = ""
    @State private var showSettingsDataDeletionConfirmation = false
    @State private var showSettingsDataDeletionWarning = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Display")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Scheme Mode")
                            .font(.body)
                            .padding(.bottom, 5)
                        Picker(selection: $settingsViewModel.colorSchemeOption, label: Text("")) {
                            Text("System").tag(0)
                            Text("Light").tag(1)
                            Text("Dark").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Capsule()
                            .foregroundColor(.blue))
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)

                    }
                }

                Section(header: Text("Data")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Button("Reset Product Data") {
                            showProductDataDeletionWarning = true
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(.red)
                        .alert(isPresented: $showProductDataDeletionWarning) {
                            Alert(
                                title: Text("Warning"),
                                message: Text("This will permanently delete all saved Product data including brand names, item names, and uploaded images. Category Data is preserved. Proceed with caution."),
                                primaryButton: .destructive(Text("Delete")) {
                                    withAnimation {
                                        for data in storedDatas {
                                            context.delete(data)

                                        }
                                        showProductDataDeletionConfirmation = true

                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }

                        Text("This will permanently delete all saved Product data including brand names, item names, and uploaded images. Category Data is preserved. Proceed with caution.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 5)
                        Divider()

                        Button("Reset Settings Data") {
                            showSettingsDataDeletionWarning = true
                        }
                        .foregroundColor(.red)
                        .buttonStyle(PlainButtonStyle())
                        .alert(isPresented: $showSettingsDataDeletionWarning) {
                            Alert(
                                title: Text("Warning"),
                                message: Text("This action will permanently restore settings to their original state. Are you sure you want to proceed?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    withAnimation {
                                        settingsViewModel.colorSchemeOption = 0
                                        showSettingsDataDeletionConfirmation = true
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }

                        Text("This will reset settings data back to default. Product and Category Data is preserved. Choose this option to restore the settings to their original state.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 5)
                        Divider()


                        Button("Reset All Data") {
                            showAllDataDeletionWarning = true
                        }
                        .foregroundColor(.red)
                        .buttonStyle(PlainButtonStyle())
                        .alert(isPresented: $showAllDataDeletionWarning) {
                            Alert(
                                title: Text("Warning"),
                                message: Text("This action will permanently delete all saved Product data, including Category Data and reset all settings to their original state. Are you sure you want to proceed?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    withAnimation {
                                        for data in storedDatas {
                                            context.delete(data)
                                        }
                                        for category in categories {
                                            context.delete(category)
                                        }
                                        settingsViewModel.colorSchemeOption = 0
                                        showAllDataDeletionConfirmation = true
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }

                        Text("This will permanently delete all saved Product data including brand names, item names, categories and uploaded images. Settings data is also reset back to default. Use this option if you want to start fresh.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 5)
                    }
                }

                Section(header: Text("About")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown")")
                            .font(.body)
                            .padding(.bottom, 5)
                        Divider()
                        Text("Developed by: Justin Aboud")
                            .font(.body)
                            .padding(.bottom, 5)
                        Divider()
                        Text("Contact: justin.aboud@icloud.com")
                            .font(.body)
                            .padding(.bottom, 5)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Product Data sucessfully deleted", isPresented: $showProductDataDeletionConfirmation){
                Button("OK") {
                    showProductDataDeletionConfirmation = false
                }
            }
            message: {
                    Text("Product Data successfully deleted, includng saved images.")
                }
            .alert("Settings Data sucessfully deleted", isPresented: $showSettingsDataDeletionConfirmation) {
                Button("OK") {
                    showSettingsDataDeletionConfirmation = false
                }
            }
            message: {
                    Text("Settings data has been reverted back to their original state.")
                }
            .alert("All data sucessfully deleted", isPresented: $showAllDataDeletionConfirmation){
                Button("OK") {
                    showAllDataDeletionConfirmation = false
                }
            }
            message: {
                    Text("All data has been successfully deleted and settings has been reverted back to their original state.")
                }
        }
    }
}

#Preview {
    SettingsView(settingsViewModel: SettingsViewModel())
}
