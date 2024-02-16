//
//  Product_SaverApp.swift
//  Product Saver
//
//  Created by Justin Aboud on 15/1/2024.
//

import SwiftUI
import SwiftData

@main
struct Product_SaverApp: App {
    @State private var settingsViewModel = SettingsViewModel()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: StoredData.self)
                .environmentObject(settingsViewModel)
                .onAppear {
                    settingsViewModel.applyColorScheme()
                    UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
                }
        }
    }
}
