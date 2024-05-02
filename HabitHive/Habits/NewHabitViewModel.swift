import Foundation
import FirebaseFirestore

class NewHabitViewModel: ObservableObject {
    private var db = Firestore.firestore()
    private var userID: String

    init(userID: String) {
            self.userID = userID
        }
    
    func saveHabitToFirestore(habit: Habit, completion: @escaping (Result<Habit, Error>) -> Void) {
        var localHabit = habit
        localHabit.userID = self.userID // Use the userID that was set during ViewModel initialization

        let habitsCollection = db.collection("habits")
        
        if localHabit.progress == nil {
            localHabit.progress = generateDateProgressMap()
        }
        
        // Create a new habit instance with the userID set
        let habitWithUserID = Habit(id: localHabit.id, name: localHabit.name, description: localHabit.description, frequency: localHabit.frequency, startDate: localHabit.startDate, daysOfWeek: localHabit.daysOfWeek, progress: localHabit.progress, userID: localHabit.userID)
        
        do {
            // Serialize the Habit object and add it to the collection
            let ref = try habitsCollection.addDocument(from: habitWithUserID)
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Use ISO-8601 format
        return formatter.string(from: date)
    }
}
