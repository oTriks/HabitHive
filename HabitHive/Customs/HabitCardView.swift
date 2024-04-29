import SwiftUI

struct HabitCardView: View {
    var habit: Habit

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

            if let days = habit.daysOfWeek, !days.isEmpty, let progressMap = habit.progress {
                ScrollableWeekdaysView(currentDate: habit.startDate, daysOfWeek: days, progressMap: progressMap)
                    .frame(height: 60) // Adjust height as needed
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
                progress[dateString] = (dayOffset == 0 ? "Done" : "Pending") // Mark today as done for visualization
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
        formatter.dateFormat = "yyyy-MM-dd" // Matching the format expected in the progress dictionary
        return formatter.string(from: date)
    }
}

struct HabitCardView_Previews: PreviewProvider {
    static var previews: some View {
        HabitCardView(habit: Habit.sampleHabit)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
