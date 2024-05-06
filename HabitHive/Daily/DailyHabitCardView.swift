import SwiftUI

struct DailyHabitCardView: View {
    @ObservedObject var viewModel: DailyViewModel

    var habit: Habit
    var progressStatus: String?
    var selectedDate: Date
    var onStreakAchieved: (Int) -> Void

    var body: some View {
           HStack {
               VStack(alignment: .leading, spacing: 8) {
                   Text(habit.name)
                       .font(.headline)
                       .foregroundColor(Color("Text primary"))

                       .frame(maxWidth: .infinity, alignment: .leading)

                   Text(habit.description)
                       .font(.subheadline)
                       .foregroundColor(Color("Text trailing"))
                       .frame(maxWidth: .infinity, alignment: .leading)
               }

               Spacer()

               let icon = iconBasedOnStatus(progressStatus)
               let color = circleFillColor(for: progressStatus)

               Image(systemName: icon)
                   .foregroundColor(.white)
                   .frame(width: 48, height: 48)
                   .background(color)
                   .clipShape(Circle())
                   .onTapGesture {
                       toggleProgressStatus()
                   }
                   .padding(10)
           }
           .padding()
           .background(cardColor(for: progressStatus))
           .cornerRadius(10)
           .shadow(radius: 5)
           .padding(.horizontal)
       }
    
    private func iconBasedOnStatus(_ status: String?) -> String {
        switch status {
        case "Done":
            return "checkmark"
        case "Failed":
            return "xmark"
        case "Pending":
            return "clock"
        default:
            return "circle"
        }
    }
    
    
    
    private func circleFillColor(for status: String?) -> Color {
        switch status {
        case "Done":
            return Color("Positive")
        case "Failed":
            return Color("Negative")
        case "Pending":
            return .orange
        default:
            return .gray 
        }
    }
    
       private func cardColor(for status: String?) -> Color {
           switch status {
           case "Done":
               return Color("Color primary")
           case "Failed":
               return Color("Color primary")
           case "Pending":
               return Color("Color primary")
           default:
               return .white
           }
       }

    
    
       private func toggleProgressStatus() {
           let dateString = formatDate(selectedDate)
           let currentStatus = habit.progress?[dateString] ?? "Pending"
           let newStatus: String

           switch currentStatus {
           case "Done":
               newStatus = "Failed"
           case "Failed":
               newStatus = "Pending"
           default:
               newStatus = "Done"
           }
           print("Toggling progress status for habit:", habit.name)
               print("Current status:", currentStatus)
               print("New status:", newStatus)
           viewModel.updateProgress(for: habit.id ?? "", on: dateString, to: newStatus)
       }
    
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
}
    

