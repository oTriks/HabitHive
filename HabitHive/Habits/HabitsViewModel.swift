
import Foundation
import Combine
import FirebaseFirestore


class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var isAddingNewHabit = false
    private var db = Firestore.firestore()
    private var userID: String?
    
    init(userID: String? = nil) {
        self.userID = userID
        
        fetchHabits()
    }
    
    func fetchHabits() {
        guard let userID = userID else {
            print("User ID not set, fetching habits is not possible")
            return
        }
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
    
    func updateHabit(habitID: String, name: String, description: String, frequency: String, startDate: Date, endDate: Date) {
        guard let index = habits.firstIndex(where: { $0.id == habitID }) else {
            print("Habit not found")
            return
        }

        // Update the habit locally
        habits[index].name = name
        habits[index].description = description
        habits[index].frequency = frequency
        habits[index].startDate = startDate
        habits[index].endDate = endDate

        let startDateTimestamp = Timestamp(date: startDate)
        let endDateTimestamp = Timestamp(date: endDate)

        let habitRef = db.collection("habits").document(habitID)
        habitRef.updateData([
            "name": name,
            "description": description,
            "frequency": frequency,
            "startDate": startDateTimestamp,
            "endDate": endDateTimestamp
        ]) { error in
            if let error = error {
                print("Error updating habit: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
                print("Habit updated successfully")
            }
        }
    }

    
    func configure(withUserID userID: String) {
        self.userID = userID
        fetchHabits()
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
