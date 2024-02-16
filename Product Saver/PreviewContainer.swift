//
//  PreviewContainer.swift
//  Product Saver
//
//  Created by Justin Aboud on 10/2/2024.
//

import Foundation
import SwiftData

struct PreviewContainer {
    let container: ModelContainer!

    init(_ types: [any PersistentModel.Type], 
         isStoredForMemoryOnly: Bool = true) {


        let schema = Schema(types)
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredForMemoryOnly)
        self.container = try! ModelContainer(for: schema, configurations: [config])
    }

    func add(storedData: [any PersistentModel]){
        Task { @MainActor in
            storedData.forEach{container.mainContext.insert($0)}
        }

    }
}


