//
//  ProductListView.swift
//  Product Saver
//
//  Created by Justin Aboud on 30/3/2024.
//

import SwiftUI

struct ProductListView: View {

    @Environment(\.modelContext) var context
    @EnvironmentObject var settings: Settings
    @State private var editProduct: Product?
    var data: [Product]

    var body: some View {
        ForEach(data) { product in
            Section {
                NavigationLink(destination: ProductDetailView(product: product)) {
                    HStack {
                        ProductRowView(product: product)
                    }
                    .sheet(item: $editProduct,
                           onDismiss: {
                        editProduct = nil
                    },
                           content: { editData in
                        NavigationStack {
                            UpdateProductDetailsView(product: editData)
                                .interactiveDismissDisabled()
                        }
                    })
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                context.delete(product)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .symbolVariant(.fill)
                        }

                        Button {
                            editProduct = product
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
        }
    }
}

struct ProductRowView: View {
    var product: Product
    @EnvironmentObject var settings: Settings

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Item Name", systemImage: "tag")
                .foregroundColor(.gray)
            Text(product.itemName)
            Label("Brand Name", systemImage: "building")
                .foregroundStyle(.gray)
            Text(product.brandName)
            if !settings.isGroupingCategories {
                Label("Category", systemImage: "folder")
                    .foregroundStyle(.gray)
                Text(product.category?.categoryName ?? "None")
            }
        }
    }
}

#Preview {
    let preview = PreviewContainer(Product.self)
    preview.addExamples(Product.sampleProducts)
    return ContentView()
        .modelContainer(preview.container)
        .environmentObject(Settings())
}
