//
//  ContentViewModel.swift
//  HabitHive
//
//  Created by Martin Larsson on 2024-04-23.
//

import Foundation
import SwiftData

class ContentViewModel: ObservableObject {
    @Published var items: [Item] = []
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchItems()
    }

    func fetchItems() {
        items = modelContext.query()
    }

    func addItem() {
        let newItem = Item(timestamp: Date())
        modelContext.insert(newItem)
        fetchItems()
    }

    func deleteItems(offsets: IndexSet) {
        offsets.forEach { index in
            modelContext.delete(items[index])
        }
        fetchItems()
    }
}
