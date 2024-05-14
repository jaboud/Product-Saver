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

    @State private var selectedTab = 0
    @StateObject private var settings = Settings()

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                ContentView()
                .tabItem {
                    Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
                    CategoriesView()
                        .tabItem {
                            Label("Category", systemImage: selectedTab == 1 ? "folder.fill" : "folder")
                                .environment(\.symbolVariants, .none)
                        }
                        .tag(1)
                    SettingsView(settings: settings)
                        .tabItem {
                            Label("Settings", systemImage: selectedTab == 2 ? "gearshape.fill" : "gearshape")
                                .environment(\.symbolVariants, .none)
                        }
                        .tag(2)
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
