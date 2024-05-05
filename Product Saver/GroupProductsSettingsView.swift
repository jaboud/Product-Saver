//
//  GroupProductsView.swift
//  Product Saver
//
//  Created by Justin Aboud on 5/5/2024.
//

import SwiftUI

struct GroupProductsSettingsView: View {

    @ObservedObject var settings: Settings

    var body: some View {
        if settings.isGroupingProducts {
            NavigationStack{
                List{
                    Picker("", selection: $settings.groupProductBy) {
                        ForEach(["Item", "Brand"], id: \.self) { productOption in
                            Text(productOption).tag(productOption)
                        }
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
                .navigationTitle("Group Products by")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    GroupProductsSettingsView(settings: Settings())
}
