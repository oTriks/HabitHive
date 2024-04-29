
import Foundation

struct Habit: Codable, Identifiable {
    var id: String?
    var name: String
    var description: String
    var frequency: String
    var startDate: Date
    var daysOfWeek: [String]?  // Array to hold days of the week
    var progress: [String: String]?  // Dictionary to track progress for each date
}
