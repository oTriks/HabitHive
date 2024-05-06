import Foundation
import Combine
import FirebaseFirestore

class ProgressViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    func configure(withUserID userID: String) {
        fetchHabits(forUserID: userID)
    }
    
    internal func fetchHabits(forUserID userID: String) {
        print("Fetching habits for user ID: \(userID)")
        listener?.remove()
        listener = db.collection("habits")
            .whereField("userID", isEqualTo: userID)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching habits: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                print("Fetched \(documents.count) documents")
                
                self.habits = documents.compactMap { queryDocumentSnapshot -> Habit? in
                    var habit = try? queryDocumentSnapshot.data(as: Habit.self)
                    habit?.id = queryDocumentSnapshot.documentID 
                    return habit
                }
            }
    }
    
}
