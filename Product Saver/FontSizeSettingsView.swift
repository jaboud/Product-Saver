//
//  FontSizeSettingsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 1/4/2024.
//

import SwiftUI

struct FontSizeSettingsView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        NavigationStack {
            VStack {
                Text("This is a sample text with the current font size. Adjust the slider to change the font size. Default font size is based on system settings.")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.primary, lineWidth: 2)
                        .frame(width: 150, height: 200, alignment: .center)
                    Text("A")
                        .font(.system(size: settings.fontSize.value))
                        .fontWeight(.bold)
                        .foregroundStyle(settings.tintColors)
                }
                .padding()
                Text("Font Size: \(self.settings.fontSize.fontSizeDescription)")
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Text("A")
                            .font(.system(size: Settings.FontSize.smallest.value))
                        Slider(value: Binding(get: {
                            CGFloat(self.settings.fontSize.rawValue)
                        }, set: { newValue in
                            if let newFontSize = Settings.FontSize(rawValue: Int(newValue.rounded())) {
                                self.settings.fontSize = newFontSize
                            }
                        }), in: 0...CGFloat(Settings.FontSize.allCases.count - 1), step: 1)
                        Text("A")
                            .font(.system(size: Settings.FontSize.largest.value))
                    }
                    .padding(.horizontal)
                    Text("Drag to change")
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        let systemFontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
                        let closestFontSize = Settings.FontSize.allCases.min(by: { abs($0.value - systemFontSize) < abs($1.value - systemFontSize) })!
                        self.settings.fontSize = closestFontSize
                    }) {
                        Text("Restore Defaults")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundStyle(settings.tintColors == .blue ? .blue : settings.tintColors)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Font Size")
            .navigationBarTitleDisplayMode(.inline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    FontSizeSettingsView()
        .environmentObject(Settings())
}

//
