//
//  ContentView.swift
//  Product Saver
//
//  Created by Justin Aboud on 15/1/2024.
//

import SwiftUI
import SwiftData

enum SortOption: String, CaseIterable {
    case RecentlyAdded = "Recently Added"
    case Oldest
    case Item
    case Brand
    case Category
}

extension SortOption {

    var systemImage: String {
        switch self {
        case .RecentlyAdded:
            "clock.arrow.circlepath"
        case .Oldest:
            "clock.arrow.2.circlepath"
        case .Item:
            "tag"
        case .Brand:
            "building"
        case .Category:
            "folder"

        }
    }
}

struct ContentView: View {

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @Query private var products: [Product]
    @State private var showCreateDetailsView = false
    @State private var showCreateCategoryView = false
    @State private var editProduct: Product?
    @State private var isFullScreen = false
    @State private var lastOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var searchQuery = ""
    @AppStorage("selectedSortOption") private var selectedSortOption: SortOption = .RecentlyAdded
    @AppStorage("selectedCategories") private var storedSelectedCategoriesData: Data = Data()
    @State private var selectedCategories: Set<String> = Set() {
        didSet {
            UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedCategories")
        }
    }
    @EnvironmentObject var settingsViewModel: SettingsViewModel

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

    func productListView(with data: [Product]) -> some View {
        ForEach(data) { product in
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
                            if !settingsViewModel.isGroupingCategories {
                                Label("Category", systemImage: "folder")
                                    .foregroundStyle(.gray)
                                Text(product.category?.categoryName ?? "None")
                            }
                        }
                    }
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
        TabView {
            NavigationStack {
                List {
                    if products.isEmpty {
                        ContentUnavailableView("No products listed. Start adding brands by tapping 'New Product'",
                                               systemImage: "archivebox")
                    }
                    else if selectedCategories.isEmpty {
                        ContentUnavailableView("You are currently hiding all categories", systemImage: "exclamationmark.triangle")
                    }
                    else {
                        if settingsViewModel.isGroupingCategories && searchQuery.isEmpty {
                            ForEach(allCategories.filter { selectedCategories.contains($0) }.sorted(), id: \.self) { category in
                                Section(header: Label(category, systemImage: "folder")) {
                                    if category == "None" {
                                        productListView(with: filteredData.filter { $0.category?.categoryName == nil })
                                    } else {
                                        productListView(with: filteredData.filter { $0.category?.categoryName == category })
                                    }
                                }
                            }
                        } else {
                            productListView(with: filteredData)
                        }                    }
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
                                ForEach(SortOption.allCases, id: \.rawValue) { option in
                                    if !(settingsViewModel.isGroupingCategories && option == .Category) {
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
            .searchable(text: $searchQuery, prompt: "Filter Product by Item or Brand")
            .sheet(isPresented: $showCreateDetailsView,
                   content: {
                NavigationStack {
                    CreateProductDetailsView()
                }
            })
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
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            CategoriesView(selectedCategories: $selectedCategories)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Category")
                }
            SettingsView(settingsViewModel: settingsViewModel)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

private extension [Product] {

    func sort(on option: SortOption) -> [Product] {
        switch option {
        case .RecentlyAdded:
            return self.sorted(by: { $0.id > $1.id })
        case .Oldest:
            return self.sorted(by: { $0.id < $1.id })
        case .Item:
            return self.sorted(by: { $0.itemName.compare($1.itemName, options: .caseInsensitive) == .orderedAscending })
        case .Brand:
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
    return ContentView()
        .modelContainer(preview.container)
        .environmentObject(SettingsViewModel())
}
