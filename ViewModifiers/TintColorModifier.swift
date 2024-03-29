//
//  TintColorModifier.swift
//  Product Saver
//
//  Created by Justin Aboud on 28/3/2024.
//

import SwiftUI

struct TintColorModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var settingsViewModel: SettingsViewModel

    func body(content: Content) -> some View {
        content
            .onAppear {
                if colorScheme == .light && settingsViewModel.tintColor == 6 {
                    settingsViewModel.tintColor = 0
                }
            }
    }
}
