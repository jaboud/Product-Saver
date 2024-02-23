//
//  StoredData.swift
//  Product Saver
//
//  Created by Justin Aboud on 15/1/2024.
//

import Foundation
import SwiftData
import UIKit

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

extension StoredData {

    static var sampleProducts: [StoredData] {
        [
            StoredData(itemName: "Milk", brandName: "Dairy Farmers", desc: "Full cream milk", notes: "Use by 25/2/2024", previewImage: "Milk"),
            StoredData(itemName: "Bread", brandName: "Wonder", desc: "White", notes: "Use by 25/2/2024", previewImage: "Bread"),
            StoredData(itemName: "Butter", brandName: "Flora Proactiv", desc: "Salted", notes: "Use by 25/2/2024", previewImage: "Butter"),
            StoredData(itemName: "Cheese", brandName: "Bega", desc: "Tasty", notes: "Use by 25/2/2024", previewImage: "Cheese"),
            StoredData(itemName: "Yoghurt", brandName: "Farmers Union", desc: "Greek", notes: "Use by 25/2/2024", previewImage: "Yogurt")
        ]
    }
}
