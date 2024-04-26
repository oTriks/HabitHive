import Foundation
import FirebaseFirestore

class NewHabitViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    func saveHabitToFirestore(habit: Habit, completion: @escaping (Result<Habit, Error>) -> Void) {
        var localHabit = habit
        let habitsCollection = Firestore.firestore().collection("habits")
        
        do {
            // Add the document to Firestore and capture the reference immediately
            let ref = try habitsCollection.addDocument(from: habit)
            // Use the reference to update the localHabit's id
            localHabit.id = ref.documentID
            
            // Use the completion block to handle the asynchronous callback for operation success or failure
            ref.getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    // If needed, update localHabit based on the document returned
                    // For instance, if the document fetches additional data you want to store
                    completion(.success(localHabit))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
