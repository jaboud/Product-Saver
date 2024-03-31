//
//  DataSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/3/2024.
//

import SwiftUI
import SwiftData

struct DataSettingsView: View {

    @Environment(\.modelContext) var context
    @ObservedObject var settings: Settings
    @Query private var products: [Product]
    @Query private var categories: [Category]
    @State private var showAllDataDeletionConfirmation = false
    @State private var showAllDataDeletionWarning = false
    @State private var showProductDataDeletionConfirmation = false
    @State private var showProductDataDeletionWarning = false
    @State private var showSettingsDataDeletionConfirmation = false
    @State private var showSettingsDataDeletionWarning = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(footer: Text("This will permanently delete all saved Product data including brand names, item names, and uploaded images. Category Data is preserved. Proceed with caution.")) {
                    Button("Reset Product Data") {
                        showProductDataDeletionWarning = true
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(settings.tintColors == .blue ? .red : settings.tintColors)
                    .actionSheet(isPresented: $showProductDataDeletionWarning) {
                        ActionSheet(
                            title: Text("Warning"),
                            message: Text("This will permanently delete all saved Product data including brand names, item names, and uploaded images. Category Data is preserved. Proceed with caution."),
                            buttons: [
                                .destructive(Text("Delete")) {
                                    withAnimation {
                                        for data in products {
                                            context.delete(data)
                                        }
                                        showProductDataDeletionConfirmation = true
                                    }
                                },
                                .cancel()
                            ]
                        )
                    }
                }

                Section(footer: Text("This will reset settings data back to default. Product and Category Data is preserved. Choose this option to restore the settings to their original state.")) {
                    Button("Reset Settings Data") {
                        showSettingsDataDeletionWarning = true
                    }
                    .foregroundColor(settings.tintColors == .blue ? .red : settings.tintColors)
                    .buttonStyle(PlainButtonStyle())
                    .actionSheet(isPresented: $showSettingsDataDeletionWarning) {
                        ActionSheet(
                            title: Text("Warning"),
                            message: Text("This action will permanently restore settings to their original state. Are you sure you want to proceed?"),
                            buttons: [
                                .destructive(Text("Delete")) {
                                    withAnimation {
                                        settings.colorSchemeOption = 0
                                        settings.isGroupingCategories = false
                                        settings.tintColor = 0
                                        showSettingsDataDeletionConfirmation = true
                                    }
                                },
                                .cancel()
                            ]
                        )
                    }
                }

                Section(footer: Text("This will permanently delete all saved Product data including brand names, item names, categories and uploaded images. Settings data is also reset back to default. Use this option if you want to start fresh.")) {
                    Button("Reset All Data") {
                        showAllDataDeletionWarning = true
                    }
                    .foregroundColor(settings.tintColors == .blue ? .red : settings.tintColors)
                    .buttonStyle(PlainButtonStyle())
                    .actionSheet(isPresented: $showAllDataDeletionWarning) {
                        ActionSheet(
                            title: Text("Warning"),
                            message: Text("This action will permanently delete all saved Product data, including Category Data and reset all settings to their original state. Are you sure you want to proceed?"),
                            buttons: [
                                .destructive(Text("Delete")) {
                                    withAnimation {
                                        for data in products {
                                            context.delete(data)
                                        }
                                        for category in categories {
                                            context.delete(category)
                                        }
                                        settings.colorSchemeOption = 0
                                        settings.isGroupingCategories = false
                                        settings.tintColor = 0
                                        showAllDataDeletionConfirmation = true
                                    }
                                },
                                .cancel()
                            ]
                        )
                    }
                }
            }
            .navigationTitle("Data")
            .navigationBarTitleDisplayMode(.inline)
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
    DataSettingsView(settings: Settings())
}
