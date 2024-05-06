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
    
    func updateProgress(for habitID: String, on dateString: String, to newStatus: String) {
           // Find the habit index
           guard let index = habits.firstIndex(where: { $0.id == habitID }) else { return }

           // Update the progress status for the given date
           habits[index].progress?[dateString] = newStatus

           // Update Firestore (replace `habits` with the relevant collection name)
           db.collection("habits").document(habitID).updateData([
               "progress.\(dateString)": newStatus
           ]) { error in
               if let error = error {
                   print("Error updating progress: \(error.localizedDescription)")
               } else {
                   // Publish changes if required
                   self.objectWillChange.send()
               }
           }
       }
    
}



