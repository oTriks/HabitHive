
import Foundation

struct Habit: Codable, Identifiable {
    var id: String?
    var name: String
    var description: String
    var frequency: String
    var startDate: Date
    var daysOfWeek: [String]?  
    var progress: [String: String]?
}
