import SwiftUI

struct DailyView: View {
    var habits: [Habit] // Assuming you have an array of habits

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(habits, id: \.id) { habit in
                    DailyHabitCardView(habit: habit) // Corrected the view name
                }
            }
            .padding()
        }
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        let habits = [
            Habit(id: "1", name: "Read Books", description: "Read at least one chapter of a non-fiction book", frequency: "Every day", startDate: Date(), daysOfWeek: ["Monday", "Wednesday", "Friday"]),
            Habit(id: "2", name: "Exercise", description: "Go for a 30-minute run", frequency: "Every day", startDate: Date(), daysOfWeek: nil)
        ]
        
        DailyView(habits: habits)
        
    }
}
