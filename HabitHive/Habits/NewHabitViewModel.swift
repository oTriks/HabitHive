import Foundation
import FirebaseFirestore

class NewHabitViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    func saveHabitToFirestore(habit: Habit, completion: @escaping (Result<Habit, Error>) -> Void) {
        var localHabit = habit
        let habitsCollection = db.collection("habits")
        
        // Ensure that the progress map is generated and assigned
        if localHabit.progress == nil {
            localHabit.progress = generateDateProgressMap()
        }
        
        do {
            // Serialize the Habit object and add it to the collection
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
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Use ISO-8601 format
        return formatter.string(from: date)
    }
}
