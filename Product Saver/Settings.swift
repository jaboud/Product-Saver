//
//  Settings.swift
//  Product Saver
//
//  Created by Justin Aboud on 22/1/2024.
//

import SwiftUI

class Settings: ObservableObject {
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

    @Published var fontSize: FontSize = .medium {
        didSet {
            UserDefaults.standard.set(fontSize.rawValue, forKey: "fontSize")
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

        if let fontSizeValue = UserDefaults.standard.object(forKey: "fontSize") as? Int,
           let fontSize = FontSize(rawValue: fontSizeValue) {
            self.fontSize = fontSize
        } else {
            let systemFontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
            let closestFontSize = FontSize.allCases.min(by: { abs($0.value - systemFontSize) < abs($1.value - systemFontSize) })!
            self.fontSize = closestFontSize
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

    enum FontSize: Int, CaseIterable {
        case smallest = 0
        case extraSmall = 1
        case small = 2
        case medium = 3
        case large = 4
        case extraLarge = 5
        case largest = 6

        var value: CGFloat {
            switch self {
            case .smallest:
                return 10
            case .extraSmall:
                return 12
            case .small:
                return 14
            case .medium:
                return 16
            case .large:
                return 18
            case .extraLarge:
                return 20
            case .largest:
                return 22
            }
        }

        var fontSizeDescription: String {
            switch self {
            case .smallest:
                return "Smallest"
            case .extraSmall:
                return "Extra Small"
            case .small:
                return "Small"
            case .medium:
                return "Medium"
            case .large:
                return "Large"
            case .extraLarge:
                return "Extra Large"
            case .largest:
                return "Largest"
            }
        }
    }
}
