import SwiftUI

struct HabitCardView: View {
    var habit: Habit
    @ObservedObject var viewModel: HabitsViewModel
    @State private var isShowingCalendar = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(habit.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
                Text(habit.frequency)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            
            if !habit.description.isEmpty {
                Text(habit.description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                isShowingCalendar = true
            }) {
                Text("Select Date")
            }
            .sheet(isPresented: $isShowingCalendar) {
                CalendarView(habitID: habit.id ?? "", viewModel: viewModel)
            }
            
            if let progressMap = habit.progress, !progressMap.isEmpty, let habitId = habit.id {
                ScrollableWeekdaysView(
                    progressMap: progressMap,
                    currentDate: Date(), 
                    habitId: habitId,
                    viewModel: viewModel
                )
                .frame(height: 60)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
