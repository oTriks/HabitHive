import Foundation
import FirebaseFirestore

class NewHabitViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var userID: String

    var endDate: Date? {
        didSet {
            // Perform any necessary actions when endDate is set
        }
    }
    
    init(userID: String) {
            self.userID = userID
        }
    
    func saveHabitToFirestore(habit: Habit, completion: @escaping (Result<Habit, Error>) -> Void) {
        var localHabit = habit
        localHabit.userID = self.userID

        // Always generate progress map for +/- 14 days
        localHabit.progress = generateDateProgressMap()

        // Generate daily map based on frequency
        localHabit.dailyMap = generateDailyMap(habit: habit)  // Generates based on frequency selection

        let habitsCollection = db.collection("habits")
        do {
            let ref = try habitsCollection.addDocument(from: localHabit)
            localHabit.id = ref.documentID
            ref.getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(localHabit))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }


    
    private func generateDateProgressMap() -> [String: String] {
        var progressMap = [String: String]()
        let calendar = Calendar.current
        let today = Date()
        
        // Range: -14 days to +14 days
        for dayOffset in -14...14 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                let dateString = formatDate(date)
                progressMap[dateString] = "Pending"
            }
        }
        return progressMap
    }
    
    private func generateDateProgressMapForSpecificDays(daysOfWeek: [Int], startDate: Date) -> [String: String] {
        var progressMap = [String: String]()
        let calendar = Calendar.current
        let range = -14...14
        for dayOffset in range {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate),
               daysOfWeek.contains(calendar.component(.weekday, from: date)) {
                let dateString = formatDate(date)
                progressMap[dateString] = "Pending"
            }
        }
        return progressMap
    }

    private func generateDateProgressMapForRepeat(everyNthDay: Int, startDate: Date) -> [String: String] {
        var progressMap = [String: String]()
        let calendar = Calendar.current
        let range = stride(from: -14, through: 14, by: everyNthDay)
        for dayOffset in range {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) {
                let dateString = formatDate(date)
                progressMap[dateString] = "Pending"
            }
        }
        return progressMap
    }

    
    private func generateDailyMap(habit: Habit) -> [String: Bool] {
        print("generateDailyMap called with frequency: \(habit.frequency)")
        switch habit.frequency {
        case "Every day":
            return generateDailyMapEveryDay(startDate: habit.startDate)
        case "Specific days":
            if let daysOfWeek = habit.daysOfWeek {
                return generateDailyMapForSpecificDays(daysOfWeek: daysOfWeek, startDate: habit.startDate)
            }
        case "Repeat":
            let repeatFrequency = 2 // Adjust based on actual input
            return generateDailyMapForRepeat(everyNthDay: repeatFrequency, startDate: habit.startDate)
        default:
            return [:] // Return an empty map if none of the conditions match
        }
        return [:] // Fallback return
    }



    private func generateDailyMapEveryDay(startDate: Date) -> [String: Bool] {
        return generateDailyMapForRange(startDate: startDate, step: 1)
    }

    private func generateDailyMapForSpecificDays(daysOfWeek: [String], startDate: Date) -> [String: Bool] {
        var map = [String: Bool]()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
        calendar.locale = Locale(identifier: "en_US")

        let range = -14...14
        let weekdayNumbers = daysOfWeek.compactMap { dayOfWeek -> Int? in
            let number = dayStringToWeekdayNumber(day: dayOfWeek)
            return number
        }

        print("Weekday numbers for days: \(daysOfWeek) are \(weekdayNumbers)")

        for dayOffset in range {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) {
                let weekday = calendar.component(.weekday, from: date)
                let dateString = formatDate(date)
                if weekdayNumbers.contains(weekday) {
                    map[dateString] = true
                    print("Included \(dateString) which is a \(weekday)")
                } else {
                    map[dateString] = false
                    print("Excluded \(dateString) which is a \(weekday)")
                }
            }
        }

        print("Final dailyMap: \(map)")
        return map
    }

    private func dayStringToWeekdayNumber(day: String) -> Int? {
        switch day {
        case "S": return 1  // Sunday
        case "M": return 2  // Monday
        case "T": return 3  // Tuesday
        case "W": return 4  // Wednesday
        case "TH": return 5 // Thursday
        case "F": return 6  // Friday
        case "SA": return 7 // Saturday
        default: return nil
        }
    }


    private func generateDailyMapForRepeat(everyNthDay: Int, startDate: Date) -> [String: Bool] {
        return generateDailyMapForRange(startDate: startDate, step: everyNthDay)
    }

    private func generateDailyMapForRange(startDate: Date, step: Int) -> [String: Bool] {
        var map = [String: Bool]()
        let calendar = Calendar.current
        let range = stride(from: -14, through: 14, by: step)
        for dayOffset in range {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) {
                let dateString = formatDate(date)
                map[dateString] = true
            }
        }
        return map
    }

    
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Use ISO-8601 format
        return formatter.string(from: date)
    }
}
