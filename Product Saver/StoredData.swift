//
//  StoredData.swift
//  Product Saver
//
//  Created by Justin Aboud on 15/1/2024.
//

import Foundation
import SwiftData

@Model
final class StoredData {
    var itemName: String
    var brandName: String
    var desc: String?
    var notes: String?

    @Relationship(deleteRule: .nullify)
    var category: Category?

    @Attribute(.externalStorage)
        var image: Data?

    init(itemName: String = "", brandName: String = "", desc: String? = "", notes: String? = "") {
        self.itemName = itemName
        self.brandName = brandName
        self.desc = desc
        self.notes = notes
    }
}
