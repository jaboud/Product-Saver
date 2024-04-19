//
//  SortOption.swift
//  Product Saver
//
//  Created by Justin Aboud on 19/4/2024.
//

import Foundation

enum SortProduct: String, CaseIterable {
    case recentlyAdded = "Recently Added"
    case oldest = "Oldest"
    case item = "Item"
    case brand = "Brand"
    case Category = "Category"
}

extension SortProduct {

    var systemImage: String {
        switch self {
        case .recentlyAdded:
            "clock.arrow.circlepath"
        case .oldest:
            "clock.arrow.2.circlepath"
        case .item:
            "tag"
        case .brand:
            "building"
        case .Category:
            "folder"
        }
    }
}
