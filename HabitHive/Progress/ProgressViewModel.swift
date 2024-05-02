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
    
    private func fetchHabits(forUserID userID: String) {
        listener?.remove() // Remove previous listener if any
        listener = db.collection("habits")
            .whereField("userID", isEqualTo: userID) // Filter habits by user ID
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.habits = documents.compactMap { queryDocumentSnapshot -> Habit? in
                    var habit = try? queryDocumentSnapshot.data(as: Habit.self)
                    habit?.id = queryDocumentSnapshot.documentID // Assigning document ID to habit's id property
                    return habit
                }
            }
    }
}
