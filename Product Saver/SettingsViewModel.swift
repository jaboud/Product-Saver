//
//  BrandSaverViewModel.swift
//  Product Saver
//
//  Created by Justin Aboud on 22/1/2024.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var colorSchemeOption: Int {
        didSet {
            UserDefaults.standard.set(colorSchemeOption, forKey: "colorSchemeOption")
            applyColorScheme()
        }
    }

    init() {
        if UserDefaults.standard.object(forKey: "colorSchemeOption") == nil {
            self.colorSchemeOption = 0
        } else {
            self.colorSchemeOption = UserDefaults.standard.integer(forKey: "colorSchemeOption")
        }
    }

    func applyColorScheme(){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        switch colorSchemeOption {
        case 0: // Defaultz
            windowScene.windows.first?.overrideUserInterfaceStyle = .unspecified
        case 1: // Light Mode
            windowScene.windows.first?.overrideUserInterfaceStyle = .light
        case 2: // Dark Mode
            windowScene.windows.first?.overrideUserInterfaceStyle = .dark
        default:
            break
        }
    }

}

