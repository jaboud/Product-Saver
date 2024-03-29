//
//  SettingsViewModel.swift
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

    @Published var isGroupingCategories: Bool = false {
        didSet {
            UserDefaults.standard.set(isGroupingCategories, forKey: "isGroupingCategories")
        }
    }

    @Published var tintColor: Int {
        didSet {
            UserDefaults.standard.set(tintColor, forKey: "tintColor")
        }
    }

    @Published var isHidingBlankData: Bool = true {
        didSet {
            UserDefaults.standard.set(isHidingBlankData, forKey: "isHidingBlankData")
        }
    }

    var tintColors: Color {
        switch tintColor {
        case 0:
            return Color.blue
        case 1:
            return Color.green
        case 2:
            return Color.red
        case 3:
            return Color.orange
        case 4:
            return Color.pink
        case 5:
            return Color.purple
        default:
            return Color.blue
        }
    }

    init() {
        self.colorSchemeOption = UserDefaults.standard.integer(forKey: "colorSchemeOption")
        
        if UserDefaults.standard.object(forKey: "isGroupingCategories") == nil {
              self.isGroupingCategories = false
          } else {
              self.isGroupingCategories = UserDefaults.standard.bool(forKey: "isGroupingCategories")
          }

        self.tintColor = UserDefaults.standard.integer(forKey: "tintColor")


        if UserDefaults.standard.object(forKey: "isHidingBlankData") == nil {
            self.isHidingBlankData = true
        } else {
            self.isHidingBlankData = UserDefaults.standard.bool(forKey: "isHidingBlankData")
        }
    }

    func applyColorScheme(){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        switch colorSchemeOption {
        case 0:
            windowScene.windows.first?.overrideUserInterfaceStyle = .unspecified
        case 1:
            windowScene.windows.first?.overrideUserInterfaceStyle = .light
        case 2:
            windowScene.windows.first?.overrideUserInterfaceStyle = .dark
        default:
            break
        }
    }
}
