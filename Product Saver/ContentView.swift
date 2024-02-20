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
            "tag.circle.fill"
        case .Brand:
            "building.2.fill"
        case .Category:
            "folder"

        }
    }
}


struct ContentView: View {

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @Query private var storedDatas: [StoredData]
    @State private var showCreateDetailsView = false
    @State private var showCreateCategoryView = false
    @State private var editStoredData: StoredData?
    @State private var isFullScreen = false
    @State private var lastOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var searchQuery = ""
    @State private var selectedSortOption = SortOption.allCases.first!
    @AppStorage("sortOption") private var storedSortOption: SortOption = .Item
    @AppStorage("selectedCategories") private var storedSelectedCategoriesData: Data = Data()
    @State private var selectedCategories: Set<String> = Set() {
        didSet {
            UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedCategories")
        }
    }

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

    var filteredData: [StoredData] {
        var data = storedDatas

        if !searchQuery.isEmpty {
            data = data.compactMap { storedData in
                let itemContainsQuery = storedData.itemName.range(of: searchQuery, options: .caseInsensitive) != nil
                let brandContainsQuery = storedData.brandName.range(of: searchQuery, options: .caseInsensitive) != nil

                return (itemContainsQuery || brandContainsQuery) ? storedData : nil
            }
        }

        if !selectedCategories.isEmpty {
            data = data.filter { storedData in
                guard let category = storedData.category?.categoryName else {
                    return selectedCategories.contains("None")
                }
                return selectedCategories.contains(category)
            }
        }

        return data.sort(on: selectedSortOption)
    }

    var allCategories: [String] {
        var categories = storedDatas.compactMap { $0.category?.categoryName }
        if storedDatas.contains(where: { $0.category?.categoryName == nil }) {
            categories.append("None")
        }
        let uniqueCategories = Set(categories)
        return Array(uniqueCategories)
    }

    var body: some View {
        TabView {
            NavigationStack {
                List {
                    if storedDatas.isEmpty {
                        ContentUnavailableView("No products listed. Start adding brands by tapping 'New Product'",
                                               systemImage: "archivebox")
                    }
                    else if selectedCategories.isEmpty {
                        ContentUnavailableView("You are currently hiding all categories", systemImage: "exclamationmark.triangle")
                    }
                    else {
                        ForEach(filteredData) { storedData in
                            NavigationLink(destination: ProductDetailView(storedData: storedData)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Item Name")
                                            .foregroundStyle(.gray)
                                        Text(storedData.itemName)
                                        Text("Brand Name")
                                            .foregroundStyle(.gray)
                                        Text(storedData.brandName)
                                        Text("Category")
                                            .foregroundStyle(.gray)
                                        Text(storedData.category?.categoryName ?? "None")
                                    }
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            context.delete(storedData)
                                        }

                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            .symbolVariant(.fill)
                                    }

                                    Button {
                                        editStoredData = storedData
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.orange)
                                }
                            }
                        }

                    }
                }
                .navigationTitle("Product Saver")
                .animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/, value: filteredData)
                .overlay {
                    if !searchQuery.isEmpty && filteredData.isEmpty && !storedDatas.isEmpty {
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
                .toolbar {
                    // ...
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
            .searchable(text: $searchQuery, prompt: "Filter by Item or Brand")
            .sheet(isPresented: $showCreateDetailsView,
                   content: {
                NavigationStack {
                    CreateProductDetailsView()
                }
            })
            .sheet(item: $editStoredData,
                   onDismiss: {
                editStoredData = nil
            },
                   content: { editData in
                NavigationStack {
                    UpdateProductDetailsView(storedData: editData)
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
            SettingsView(settingsViewModel: SettingsViewModel())
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }

}



private extension [StoredData] {

    func sort(on option: SortOption) -> [StoredData] {
        switch option {
        case .RecentlyAdded:
            return self.sorted(by: { $0.id > $1.id })
        case .Oldest:
            return self.sorted(by: { $0.id < $1.id })
        case .Item:
            return self.sorted(by: { $0.itemName < $1.itemName })
        case .Brand:
            return self.sorted(by: { $0.brandName < $1.brandName })
        case .Category:
            return self.sorted(by: {
                guard let firstCategoryName = $0.category?.categoryName,
                      let secondCategoryName = $1.category?.categoryName else { return false }
                return firstCategoryName < secondCategoryName
            })
        }
    }
}

#Preview {
    ContentView()
}
