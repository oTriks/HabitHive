import SwiftUI

struct DailyHabitCardView: View {
    var habit: Habit
    var progressStatus: String? // Status for the selected date

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(habit.name)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(habit.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()

            Image(systemName: iconBasedOnStatus(progressStatus))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)
                .background(circleFillColor(for: progressStatus))
                .clipShape(Circle())
                .padding(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
    
    // Determines the icon based on the progress status
    private func iconBasedOnStatus(_ status: String?) -> String {
        switch status {
        case "Done":
            return "checkmark"
        case "Failed":
            return "xmark"
        case "Pending":
            return "clock"
        default:
            return "circle" // Default icon if no status
        }
    }
    
    
    
    // Determines the circle fill color based on the progress status
    private func circleFillColor(for status: String?) -> Color {
        switch status {
        case "Completed":
            return .green
        case "Failed":
            return .red
        case "Pending":
            return .orange
        default:
            return .gray // Default color if no status
        }
    }
}
    

