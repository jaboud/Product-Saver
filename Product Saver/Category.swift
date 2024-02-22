//
//  Category.swift
//  Product Saver
//
//  Created by Justin Aboud on 22/2/2024.
//

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

