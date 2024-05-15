//
//  Category.swift
//  Product Saver
//
//  Created by Justin Aboud on 22/2/2024.
//

import SwiftData

@Model
class Category {

    var categoryName: String = "" 
    var isSelected: Bool = true
    var products: [Product]?

    init(categoryName: String = "") {
        self.categoryName = categoryName
    }
}

extension Category {
    static var sampleCategories: [Category] {
        [
            Category(categoryName: "Dairy"),
            Category(categoryName: "Bakery"),
            Category(categoryName: "Fruit and Vegetables"),
            Category(categoryName: "Meat and Seafood"),
            Category(categoryName: "Pantry"),
            Category(categoryName: "Frozen")
        ]
    }
}
