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
        let categories = Category.sampleCategories
        let categoryDict = Dictionary(uniqueKeysWithValues: categories.map { ($0.categoryName, $0) })

        return [
            Product(itemName: "Milk", brandName: "Dairy Farmers", desc: "Full cream milk", notes: "Use by 25/2/2024", previewImage: "Milk").assjgnCategory(from: categoryDict),
            Product(itemName: "Bread", brandName: "Wonder", desc: "White", notes: "Use by 25/2/2024", previewImage: "Bread").assjgnCategory(from: categoryDict),
            Product(itemName: "Butter", brandName: "Flora Proactiv", desc: "Salted", notes: "Use by 25/2/2024", previewImage: "Butter").assjgnCategory(from: categoryDict),
            Product(itemName: "Cheese", brandName: "Bega", desc: "Tasty", notes: "Use by 25/2/2024", previewImage: "Cheese").assjgnCategory(from: categoryDict),
            Product(itemName: "Yoghurt", brandName: "Farmers Union", desc: "Greek", notes: "Use by 25/2/2024", previewImage: "Yogurt").assjgnCategory(from: categoryDict)
        ]
    }

    func assjgnCategory(from dict: [String: Category]) -> Self {
        switch self.itemName {
        case "Milk", "Butter", "Cheese", "Yoghurt":
            self.category = dict["Dairy"]
        case "Bread":
            self.category = dict["Bakery"]
        default:
            break
        }
        return self
    }
}
