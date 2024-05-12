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
    @AppStorage("selectedCategories") private var storedSelectedCategoriesData: Data = Data()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @EnvironmentObject var settings: Settings
    @Query private var products: [Product]
    @State private var showCreateDetailsView = false
    @State private var showCreateCategoryView = false
    @State private var searchQuery = ""
    @State private var selectedCategories: Set<String> = Set() {
        didSet {
            UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedCategories")
        }
    }
    @State private var selectedTab = 0

    init() {
        if let storedSelectedCategories = UserDefaults.standard.array(forKey: "selectedCategories") as? [String] {
            _selectedCategories = State(initialValue: Set(storedSelectedCategories))
        } else {
            var categories = Set(allCategories)
            categories.insert("None")
            _selectedCategories = State(initialValue: categories)
            UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedCategories")
        }
    }

    var filteredData: [Product] {
        var data = products

        if !searchQuery.isEmpty {
            data = data.compactMap { product in
                let itemContainsQuery = product.itemName.range(of: searchQuery, options: .caseInsensitive) != nil
                let brandContainsQuery = product.brandName.range(of: searchQuery, options: .caseInsensitive) != nil

                return (itemContainsQuery || brandContainsQuery) ? product : nil
            }
        }

        if !selectedCategories.isEmpty {
            data = data.filter { product in
                guard let category = product.category?.categoryName else {
                    return selectedCategories.contains("None")
                }
                return selectedCategories.contains(category)
            }
        }

        return data.sort(on: selectedSortOption)
    }

    var allCategories: [String] {
        var categories = products.compactMap { $0.category?.categoryName }
        if products.contains(where: { $0.category?.categoryName == nil }) {
            categories.append("None")
        }
        let uniqueCategories = Set(categories)
        return Array(uniqueCategories)
    }

    var groupedData: [String: [Product]] {
        if settings.isGroupingProducts && searchQuery.isEmpty {
            if settings.groupProductBy == "Item" {
                return Dictionary(grouping: filteredData) { String($0.itemName.prefix(1)) }
            } else if settings.groupProductBy == "Brand" {
                return Dictionary(grouping: filteredData) { String($0.brandName.prefix(1)) }
            }
        }
        return [:]
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                VStack {
                    if (!filteredData.isEmpty) && (settings.isGroupingProducts || settings.isGroupingCategories) {
                        Text("Grouping by: \(settings.isGroupingProducts ? settings.groupProductBy : "Categories")")
                            .font(.headline)
                    }
                    List {
                        if products.isEmpty {
                            ContentUnavailableView("No products listed. Start adding brands by tapping 'New Product'",
                                                   systemImage: "archivebox")
                        }
                        else if selectedCategories.isEmpty {
                            ContentUnavailableView("You are currently hiding all categories", systemImage: "exclamationmark.triangle")
                        }
                        else {
                            if !groupedData.isEmpty {
                                ForEach(groupedData.keys.sorted(), id: \.self) { key in
                                    Section(header: Label(key, systemImage: settings.groupProductBy == "Item" ? "tag" : "building")) {
                                        ProductListView(data: groupedData[key] ?? [])
                                    }
                                }
                            } else if settings.isGroupingCategories && searchQuery.isEmpty {
                                ForEach(allCategories.filter { selectedCategories.contains($0) }.sorted(), id: \.self) { category in
                                    Section(header: Label(category, systemImage: "folder")) {
                                        if category == "None" {
                                            ProductListView(data: filteredData.filter { $0.category?.categoryName == nil })
                                        } else {
                                            ProductListView(data: filteredData.filter { $0.category?.categoryName == category })
                                        }
                                    }
                                }
                            } else {
                                ProductListView(data: filteredData)
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
                                    if !(settings.isGroupingCategories && option == .Category) {
                                        Label(option.rawValue.capitalized, systemImage: option.systemImage)
                                            .tag(option)
                                    }
                                }
                            }
                            .labelsHidden()
                        } label: {
                            Image(systemName: "ellipsis")
                                .symbolVariant(.circle)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Section {
                                if allCategories.isEmpty {
                                    Text("No categories to filter")
                                }
                                else{
                                    Text("Filter by category")
                                }
                            }
                            ForEach(allCategories, id: \.self) { category in
                                Toggle(isOn: Binding(
                                    get: { self.selectedCategories.contains(category) },
                                    set: { if $0 { self.selectedCategories.insert(category) } else { self.selectedCategories.remove(category) } }
                                )) {
                                    Text(category)
                                }
                            }
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease.circle")
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
            .tabItem {
                Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
                    .environment(\.symbolVariants, .none)
            }
            .tag(0)
            CategoriesView(selectedCategories: $selectedCategories)
                .tabItem {
                    Label("Category", systemImage: selectedTab == 1 ? "folder.fill" : "folder")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)
            SettingsView(settings: settings)
                .tabItem {
                    Label("Settings", systemImage: selectedTab == 2 ? "gearshape.fill" : "gearshape")
                        .environment(\.symbolVariants, .none)
                }
                .tag(2)
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

private extension [Product] {

    func sort(on option: SortProduct) -> [Product] {
        switch option {
        case .recentlyAdded:
            return self.sorted(by: { $0.id > $1.id })
        case .oldest:
            return self.sorted(by: { $0.id < $1.id })
        case .item:
            return self.sorted(by: { $0.itemName.compare($1.itemName, options: .caseInsensitive) == .orderedAscending })
        case .brand:
            return self.sorted(by: { $0.brandName.compare($1.brandName, options: .caseInsensitive) == .orderedAscending })
        case .Category:
            return self.sorted(by: {
                let firstCategoryName = $0.category?.categoryName ?? "None"
                let secondCategoryName = $1.category?.categoryName ?? "None"
                return firstCategoryName.compare(secondCategoryName, options: .caseInsensitive) == .orderedAscending
            })
        }
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
