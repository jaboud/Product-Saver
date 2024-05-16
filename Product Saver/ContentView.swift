//
//  ContentView.swift
//  Product Saver
//
//  Created by Justin Aboud on 15/1/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @AppStorage("selectedSortOption") private var selectedSortOption: SortProduct = .recentlyAdded
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @EnvironmentObject var settings: Settings
    @Query private var products: [Product]
    @State private var editProduct: Product?
    @State private var showCreateDetailsView = false
    @State private var searchQuery = ""

    private func filterProducts(_ products: [Product], query: String) -> [Product] {
        return products.filter { product in
            let itemContainsQuery = product.itemName.range(of: query, options: .caseInsensitive) != nil
            let brandContainsQuery = product.brandName.range(of: query, options: .caseInsensitive) != nil
            return itemContainsQuery || brandContainsQuery
        }
    }

    private func groupProducts(_ products: [Product]) -> [String: [Product]] {
        switch (settings.isGroupingCategories, settings.isGroupingProducts && searchQuery.isEmpty) {
        case (true, _):
            return Dictionary(grouping: products) { $0.category?.categoryName ?? "None" }
        case (_, true):
            let keyPath: KeyPath<Product, String> = settings.groupProductBy == "Item" ? \.itemName : \.brandName
            return Dictionary(grouping: products) { String($0[keyPath: keyPath].prefix(1)) }
        default:
            return [:]
        }
    }

    private func sortProducts(_ products: [Product], by option: SortProduct) -> [Product] {
        switch option {
        case .recentlyAdded:
            return products.sorted(by: { $0.id > $1.id })
        case .oldest:
            return products.sorted(by: { $0.id < $1.id })
        case .item:
            return products.sorted(by: { $0.itemName.compare($1.itemName, options: .caseInsensitive) == .orderedAscending })
        case .brand:
            return products.sorted(by: { $0.brandName.compare($1.brandName, options: .caseInsensitive) == .orderedAscending })
        case .Category:
            return products.sorted(by: {
                let firstCategoryName = $0.category?.categoryName ?? "None"
                let secondCategoryName = $1.category?.categoryName ?? "None"
                return firstCategoryName.compare(secondCategoryName, options: .caseInsensitive) == .orderedAscending
            })
        }
    }

    var filteredData: [Product] {
        var data = products
        if !searchQuery.isEmpty {
            data = filterProducts(data, query: searchQuery)
        }
        return sortProducts(data, by: selectedSortOption)
    }

    var groupedData: [String: [Product]] {
        return groupProducts(filteredData)
    }

    func productListView(products: [Product]) -> some View {
        ForEach(products) { product in
            Section {
                NavigationLink(destination: ProductDetailView(product: product)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Item Name", systemImage: "tag")
                                .foregroundColor(.gray)
                            Text(product.itemName)
                            Label("Brand Name", systemImage: "building")
                                .foregroundStyle(.gray)
                            Text(product.brandName)
                            Label("Category", systemImage: "folder")
                                .foregroundStyle(.gray)
                            Text(product.category?.categoryName ?? "None")
                        }
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

    var body: some View {
        NavigationStack {
            VStack {
                if (!filteredData.isEmpty) && (settings.isGroupingProducts || settings.isGroupingCategories) {
                    Section {
                        Text("Grouping by: \(settings.isGroupingProducts ? settings.groupProductBy : "Categories")")
                            .font(.headline)
                    }
                }
                List {
                    if products.isEmpty {
                        ContentUnavailableView("No products listed. Start adding brands by tapping 'New Product'",
                                               systemImage: "archivebox")
                    }
                    else {
                        if !groupedData.isEmpty {
                            ForEach(groupedData.keys.sorted(), id: \.self) { key in
                                Section(header: settings.isGroupingCategories ?
                                        Label(key, systemImage: "folder") :
                                            Label(key, systemImage: settings.groupProductBy == "Item" ? "tag" : "building")) {
                                    productListView(products: groupedData[key] ?? [])
                                }
                            }
                        }
                        else {
                            productListView(products: filteredData)
                        }
                    }
                }
            }
            .navigationTitle("Product Saver")
            .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: filteredData)
            .overlay {
                if !searchQuery.isEmpty && filteredData.isEmpty && !products.isEmpty {
                    ContentUnavailableView.search
                }
            }

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section {
                            Text("Sort Product")
                        }
                        Picker("", selection: $selectedSortOption) {
                            ForEach(SortProduct.allCases, id: \.rawValue) { option in
                                Label(option.rawValue.capitalized, systemImage: option.systemImage)
                                    .tag(option)
                            }
                        }
                        .labelsHidden()
                    } label: {
                        Image(systemName: "ellipsis")
                            .symbolVariant(.circle)
                    }
                }
            }
            .safeAreaInset(edge: .bottom,
                           alignment: .leading) {
                Button(action: {
                    showCreateDetailsView.toggle()
                }, label: {
                    Label("New Product", systemImage: "plus")
                        .bold()
                        .font(.title2)
                        .padding(8)
                        .background(
                            Color(UIColor.systemBackground).colorInvert()
                        )
                        .clipShape(Capsule())
                        .padding(.leading)
                        .symbolVariant(.circle.fill)
                })
            }
        }
        .searchable(text: $searchQuery, prompt: "Filter Product by Item or Brand")
        .sheet(isPresented: $showCreateDetailsView,
               content: {
            NavigationStack {
                CreateProductDetailsView()
            }
        })
    }
}

#Preview {
    let preview = PreviewContainer(Product.self)
    preview.addExamples(Product.sampleProducts)
    let settings = Settings()
    settings.isGroupingCategories = true
    return ContentView()
        .modelContainer(preview.container)
        .environmentObject(Settings())
}
