//
//  SettingsIconStyle.swift
//  Product Saver
//
//  Created by Justin Aboud on 31/3/2024.
//

import SwiftUI

struct SettingsIconStyle: LabelStyle {
    var color: Color
    var size: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            configuration.icon
                .imageScale(.small)
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 7 * size).frame(width: 28 * size, height: 28 * size).foregroundColor(color))
        }
    }
}
