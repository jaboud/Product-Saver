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

    @StateObject private var settings = Settings()
    @State private var selectedCategories: Set<String> = Set() {
        didSet {
            UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedCategories")
        }
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                CategoriesView(selectedCategories: $selectedCategories)
                    .tabItem {
                        Image(systemName: "folder")
                        Text("Category")
                    }
                SettingsView(settings: settings)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
            }
            .modelContainer(for: Product.self)
            .environmentObject(settings)
            .font(.system(size: settings.fontSize.value))
            .tint(settings.tintColors)
            .onAppear(){
                UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
                settings.applyColorScheme()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                settings.applyColorScheme()
            }
        }
    }
}
