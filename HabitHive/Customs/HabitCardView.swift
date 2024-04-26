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

            // Using ScrollableWeekdaysView
            if let days = habit.daysOfWeek, !days.isEmpty {
                ScrollableWeekdaysView(currentDate: habit.startDate, daysOfWeek: days)
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
        Habit(id: "1", name: "Read Books", description: "Read at least one chapter of a non-fiction book", frequency: "Every day", startDate: Date(), daysOfWeek: ["Monday", "Tuesday","Wednesday", "Thursday", "Friday", "Saturday","Sunday"])
    }
}

struct HabitCardView_Previews: PreviewProvider {
    static var previews: some View {
        HabitCardView(habit: Habit.sampleHabit)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

