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

    var body: some Scene {
        WindowGroup {
            ContentView()
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
