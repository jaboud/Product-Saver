//
//  Product.swift
//  Product Saver
//
//  Created by Justin Aboud on 15/1/2024.
//

import Foundation
import SwiftData
import UIKit

@Model
final class Product {
    var itemName: String = ""
    var brandName: String = ""
    var desc: String?
    var notes: String?

    @Relationship(deleteRule: .nullify)
    var category: Category?

    @Attribute(.externalStorage)
    var image: Data?

    init(itemName: String = "", brandName: String = "", desc: String? = "", notes: String? = "", previewImage: String? = nil) {
        self.itemName = itemName
        self.brandName = brandName
        self.desc = desc
        self.notes = notes

        if let previewImage = previewImage, let mockImage = UIImage(named: previewImage) {
            self.image = mockImage.jpegData(compressionQuality: 0.8)
        }
    }
}

extension Product {

    static var sampleProducts: [Product] {
        [
            Product(itemName: "Milk", brandName: "Dairy Farmers", desc: "Full cream milk", notes: "Use by 25/2/2024", previewImage: "Milk"),
            Product(itemName: "Bread", brandName: "Wonder", desc: "White", notes: "Use by 25/2/2024", previewImage: "Bread"),
            Product(itemName: "Butter", brandName: "Flora Proactiv", desc: "Salted", notes: "Use by 25/2/2024", previewImage: "Butter"),
            Product(itemName: "Cheese", brandName: "Bega", desc: "Tasty", notes: "Use by 25/2/2024", previewImage: "Cheese"),
            Product(itemName: "Yoghurt", brandName: "Farmers Union", desc: "Greek", notes: "Use by 25/2/2024", previewImage: "Yogurt")
        ]
    }
}
