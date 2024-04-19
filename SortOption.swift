//
//  SortOption.swift
//  Product Saver
//
//  Created by Justin Aboud on 19/4/2024.
//

import Foundation

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
            "tag"
        case .Brand:
            "building"
        case .Category:
            "folder"

        }
    }
}
