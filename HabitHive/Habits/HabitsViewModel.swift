
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


    func updateProgress(for habitID: String, date: String) {
        guard let index = self.habits.firstIndex(where: { $0.id == habitID }),
              let currentStatus = self.habits[index].progress?[date] else {
            print("Habit or date not found")
            return
        }
        
        let newStatus: String
        switch currentStatus {
            case "Done":
                newStatus = "Failed"
            case "Failed":
                newStatus = "Pending"
            default:
                newStatus = "Done"
        }
        
        let updatePath = "progress.\(date)"
        let habitRef = db.collection("habits").document(habitID)
        
        habitRef.updateData([updatePath: newStatus]) { error in
            if let error = error {
                print("Error updating progress: \(error)")
            } else {
                self.habits[index].progress?[date] = newStatus
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
                print("Progress updated successfully to \(newStatus)")
            }
        }
    }




    
    
    func addNewHabit() {
        isAddingNewHabit = true
    }
}
