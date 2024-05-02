
import Foundation
import Combine
import FirebaseFirestore


class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
       @Published var isAddingNewHabit = false
       private var db = Firestore.firestore()
    
    init() {
           fetchHabits()
       }
    
    func fetchHabits() {
        db.collection("habits").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.habits = documents.compactMap { queryDocumentSnapshot -> Habit? in
                guard var habitData = try? queryDocumentSnapshot.data(as: Habit.self) else {
                    return nil
                }
                
                habitData.id = queryDocumentSnapshot.documentID
                return habitData
            }
        }
    }


    func updateProgress(for habitID: String, date: String, status: String) {
        let habitRef = db.collection("habits").document(habitID)
        let updatePath = "progress.\(date)"

        // Update Firestore
        habitRef.updateData([updatePath: status]) { error in
            if let error = error {
                print("Error updating progress: \(error)")
            } else {
                // Update local data
                if let index = self.habits.firstIndex(where: { $0.id == habitID }) {
                    self.habits[index].progress?[date] = status
                    DispatchQueue.main.async {
                        self.objectWillChange.send()  // Notify observers of the data change
                    }
                }
                print("Progress updated successfully")
            }
        }
    }


    
    
    func addNewHabit() {
        isAddingNewHabit = true
    }
}
