//
//  AboutView.swift
//  Product Saver
//
//  Created by Justin Aboud on 29/3/2024.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        Section(header: Label("About", systemImage: "info.circle")) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Product Saver")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                Image("Settings")
                    .frame(maxWidth: .infinity, alignment: .center)
                VStack {
                    Text("Version: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown")")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    Text("Est. 2024")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Text("Designed and Developed by")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Justin Aboud")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
            }

        }
    }
}

#Preview {
    AboutView()
}
