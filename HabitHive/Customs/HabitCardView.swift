import SwiftUI

struct HabitCardView: View {
    var habit: Habit
    @ObservedObject var viewModel: HabitsViewModel

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

            // Pass the current date instead of the habit's `startDate`
            if let progressMap = habit.progress, !progressMap.isEmpty, let habitId = habit.id {
                ScrollableWeekdaysView(
                    progressMap: progressMap,
                    currentDate: Date(), // Pass today's date
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
