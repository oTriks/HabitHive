
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
                   try? queryDocumentSnapshot.data(as: Habit.self)
               }
           }
       }
    
    func addNewHabit() {
        isAddingNewHabit = true
    }
}
