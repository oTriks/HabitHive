//
//  Item.swift
//  HabitHive
//
//  Created by Martin Larsson on 2024-04-23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
