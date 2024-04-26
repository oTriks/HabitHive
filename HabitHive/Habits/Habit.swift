//
//  Habit.swift
//  HabitHive
//
//  Created by Martin Larsson on 2024-04-26.
//

import Foundation

struct Habit: Codable, Identifiable {
    var id: String? 
    var name: String
    var description: String
    var frequency: String
    var startDate: Date
    var daysOfWeek: [String]?  // Array to hold days of the week

}

