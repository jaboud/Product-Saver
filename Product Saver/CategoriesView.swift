//
//  CreateCategoryView.swift
//  Product Saver
//
//  Created by Justin Aboud on 16/1/2024.
//

import SwiftUI
import SwiftData

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
    @Binding var selectedCategories: Set<String>
    @State private var showDuplicatedCategoryAlert = false

    var body: some View {
        NavigationStack{
            List{
                Section("Create Category") {
                    TextField("Category Name", text: $categoryName)
                    Button("Add Category"){
                        withAnimation {
                            let lowercasedCategories = categories.map { $0.categoryName.lowercased() }
                            if !lowercasedCategories.contains(categoryName.lowercased()) {
                                let category = Category(categoryName: categoryName)
                                context.insert(category)
                                category.storedDatas = []
                                categoryName = ""
                                selectedCategories.insert(category.categoryName)
                                UserDefaults.standard.set(Array(selectedCategories), forKey: "selectedCategories")
                            } else {
                                showDuplicatedCategoryAlert = true
                            }
                        }
                    }
                    .disabled(categoryName.isEmpty)
                    .alert(isPresented: $showDuplicatedCategoryAlert) {
                        Alert(title: Text("Duplicate Category"), message: Text("'\(categoryName)' already exists."), dismissButton: .default(Text("OK")))
                    }
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
        let preview = PreviewContainer(Category.self)
        let selectedCategories = Binding.constant(Set<String>())
        preview.addExamples(Category.sampleCategories)
    return CategoriesView(selectedCategories: selectedCategories)
            .modelContainer(preview.container)
}
