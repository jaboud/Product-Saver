//
//  CreateCategoryView.swift
//  Product Saver
//
//  Created by Justin Aboud on 16/1/2024.
//

import SwiftUI
import SwiftData

@Model
class Category {
    @Attribute(.unique)

    var categoryName: String
    var storedDatas: [StoredData]?

    init(categoryName: String = "") {
        self.categoryName = categoryName
    }
}

enum SortCategory: String, CaseIterable {
    case RecentlyAdded = "Recently Added"
    case Oldest
    case AlphabeticalAZ = "Alphabetical (A-Z)"
    case AlphabeticalZA = "Alphabetical (Z-A)"
}

extension SortCategory {

    var systemImage: String {
        switch self {
        case .RecentlyAdded:
            "clock.arrow.circlepath"
        case .Oldest:
            "clock.arrow.2.circlepath"
        case .AlphabeticalAZ:
            "arrow.up.right.square"
        case .AlphabeticalZA:
            "arrow.down.left.square"
        }
    }
}


struct CategoriesView: View {

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query private var categories: [Category]
    @State private var categoryName: String = ""
    @AppStorage("selectedSortCategory") private var selectedSortCategory: SortCategory = .RecentlyAdded

    var body: some View {
        NavigationStack{
            List{
                Section("Create Category") {
                    TextField("Category Name", text: $categoryName)
                    Button("Add Category"){
                        withAnimation {
                            let category = Category(categoryName: categoryName)
                            context.insert(category)
                            category.storedDatas = []
                            categoryName = ""
                        }
                    }
                    .disabled(categoryName.isEmpty)
                }
                Section("Categories") {
                    if categories.isEmpty {
                        ContentUnavailableView("No Categories",
                                               systemImage: "archivebox")
                    }
                    else {
                        ForEach(categories.sort(on: selectedSortCategory)) { category in
                            Text(category.categoryName)
                                .swipeActions() {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            context.delete(category)
                                        }
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                            .symbolVariant(.fill)
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Section {
                            Text("Sort Category")
                        }
                        Picker("", selection: $selectedSortCategory) {
                            ForEach(SortCategory.allCases, id: \.rawValue) { option in
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
        }
    }
}

private extension [Category] {

    func sort(on option: SortCategory) -> [Category] {
        switch option {
        case .RecentlyAdded:
            return self.sorted(by: { $0.categoryName > $1.categoryName })
        case .Oldest:
            return self.sorted(by: { $0.categoryName < $1.categoryName })
        case .AlphabeticalAZ:
            return self.sorted(by: { $0.categoryName.lowercased() < $1.categoryName.lowercased() })
        case .AlphabeticalZA:
            return self.sorted(by: { $0.categoryName.lowercased() > $1.categoryName.lowercased() })
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesView()
    }
}
