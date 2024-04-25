
import Foundation


class HabitsViewModel: ObservableObject {
    @Published var isAddingNewHabit = false
    
    func addNewHabit() {
        isAddingNewHabit = true
    }
}
