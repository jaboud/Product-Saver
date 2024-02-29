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
    @StateObject private var settingsViewModel = SettingsViewModel()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: StoredData.self)
                .environmentObject(settingsViewModel)
                .accentColor(settingsViewModel.tintColors)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    settingsViewModel.applyColorScheme()
                    UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
                }
        }
    }
}
