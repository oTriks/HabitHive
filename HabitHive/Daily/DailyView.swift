import SwiftUI

struct DailyView: View {
    @ObservedObject var viewModel = DailyViewModel()
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollDaysView(startDate: Date().addingTimeInterval(-60 * 24 * 60 * 60), // Start 60 days earlier
                               endDate: Date().addingTimeInterval(60 * 24 * 60 * 60),    // End 60 days later
                               selectedDate: $selectedDate)
                
                ScrollView {
                    LazyVStack(spacing: 95) {
                        ForEach(viewModel.habits, id: \.id) { habit in
                            DailyHabitCardView(habit: habit)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchHabits()
                selectedDate = Date() // Set selectedDate to current date
            }
        }
    }
}


    
  


struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = DailyViewModel()
        viewModel.habits = [
            Habit(id: "1", name: "Exercise", description: "Daily workout", frequency: "Daily", startDate: Date(), daysOfWeek: nil, progress: nil, userID: "userID1"),
            Habit(id: "2", name: "Read", description: "Read a book", frequency: "Weekly", startDate: Date(), daysOfWeek: ["Monday"], progress: nil, userID: "userID2")
            // Add more sample habits as needed
        ]
        return DailyView(viewModel: viewModel)
    }
}
