import Foundation
import Combine
import FirebaseFirestore

class DailyViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    @Published var progressMap: [String: String] = [:]

    deinit {
        listener?.remove()
    }
    
    init() {
        fetchHabits()
    }
    
    func fetchHabits() {
        listener = db.collection("habits").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.habits = documents.compactMap { queryDocumentSnapshot -> Habit? in
                var habit = try? queryDocumentSnapshot.data(as: Habit.self)
                habit?.id = queryDocumentSnapshot.documentID 
                return habit
            }
        }
    }
    
    
    
}



