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

           
            if let progressMap = habit.progress, !progressMap.isEmpty, let habitId = habit.id {
                ScrollableWeekdaysView(progressMap: progressMap, currentDate: habit.startDate, habitId: habitId, viewModel: viewModel)
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




extension Habit {
    static var sampleHabit: Habit {
        let startDate = Date() // Today’s date for simplicity
        let calendar = Calendar.current
        var progress: [String: String] = [:]
        
        // Generating a date range from -2 to +2 days from startDate
        for dayOffset in -2...2 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) {
                let dateString = formatDate(date)
                progress[dateString] = (dayOffset == 0 ? "Done" : "Pending")
            }
        }
        
        return Habit(
            id: "1",
            name: "Read Books",
            description: "Read at least one chapter of a non-fiction book",
            frequency: "Every day",
            startDate: startDate,
            daysOfWeek: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
            progress: progress
        )
    }
    
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct HabitCardView_Previews: PreviewProvider {
    static var previews: some View {
        HabitCardView(habit: Habit.sampleHabit, viewModel: HabitsViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

