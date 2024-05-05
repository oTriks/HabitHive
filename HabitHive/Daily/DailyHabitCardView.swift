import SwiftUI

struct DailyHabitCardView: View {
    @ObservedObject var viewModel: DailyViewModel

    var habit: Habit
    var progressStatus: String? // Status for the selected date
    var selectedDate: Date

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
    
    // Determines the card color based on the progress status
       private func cardColor(for status: String?) -> Color {
           switch status {
           case "Done":
               return Color("Primary") // Define a color in Assets.xcassets
           case "Failed":
               return Color("Primary") // Define a color in Assets.xcassets
           case "Pending":
               return Color("Primary") // Define a color in Assets.xcassets
           default:
               return .white // Default background color
           }
       }

    
    
    // Toggle the progress status based on the current value
       private func toggleProgressStatus() {
           let dateString = formatDate(selectedDate)
           let currentStatus = habit.progress?[dateString] ?? "Pending"
           let newStatus: String

           // Switch status logic here as per your requirements
           switch currentStatus {
           case "Done":
               newStatus = "Failed"
           case "Failed":
               newStatus = "Pending"
           default:
               newStatus = "Done"
           }

           // Update the habit's progress map
           viewModel.updateProgress(for: habit.id ?? "", on: dateString, to: newStatus)
       }
    
    // Format the date to the required string format
        private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    
    
    
}
    

