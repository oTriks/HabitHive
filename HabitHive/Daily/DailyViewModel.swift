import Foundation
import Combine
import FirebaseFirestore

class DailyViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private let milestones = [1, 3, 7, 14, 30]
    
    deinit {
        listener?.remove()
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
    
    private func calculateCurrentStreak(for habit: Habit) -> Int {
        guard let progress = habit.progress else {
            return 0
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let sortedProgress = progress.sorted(by: { dateFormatter.date(from: $0.key)! < dateFormatter.date(from: $1.key)! })
        
        print("Sorted Progress Array:", sortedProgress)
        
        var currentStreak = 0
        var previousDate: Date?
        
        for (dateString, status) in sortedProgress {
            print("Date String:", dateString)
            if let date = dateFormatter.date(from: dateString) {
                print("Date:", date)
            }
            
            if let date = dateFormatter.date(from: dateString) {
                if let previousDate = previousDate {
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.day], from: previousDate, to: date)
                    
                    if components.day == 1 {
                        if status == "Done" {
                            currentStreak += 1
                        }
                    } else {
                        currentStreak = 0
                    }
                }
                previousDate = date
            }
        }
        
        return currentStreak
    }
    
    
    
    func updateProgress(for habitID: String, on dateString: String, to newStatus: String) -> Int? {
        guard let index = habits.firstIndex(where: { $0.id == habitID }) else { return nil }
        habits[index].progress?[dateString] = newStatus
        print("Updated progress status for habit ID:", habitID, "on date:", dateString, "to:", newStatus)
        
        db.collection("habits").document(habitID).updateData([
            "progress.\(dateString)": newStatus
        ]) { error in
            if let error = error {
                print("Error updating progress: \(error.localizedDescription)")
            } else {
                self.objectWillChange.send()
            }
        }
        
        let currentStreak = calculateCurrentStreak(for: habits[index])
        print("Current streak for habit ID:", habitID, "is:", currentStreak)
        
        if milestones.contains(currentStreak) {
            print("Milestone achieved for habit ID:", habitID, "with streak:", currentStreak)
            
            return currentStreak
        }
        
        return nil
    }
}
