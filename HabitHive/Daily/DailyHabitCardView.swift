import SwiftUI

struct DailyHabitCardView: View {
    var habit: Habit
    var progressStatus: String?  // Status for the selected date

    @State private var isSelected = false
    
    var body: some View {
        GeometryReader { geometry in
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
                
                
                
                Image(systemName: iconBasedOnStatus())
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(isSelected ? Color.green : Color.gray)
                    .clipShape(Circle())
                    .onTapGesture {
                        isSelected.toggle()
                    }
                .padding(10)
            }
            .padding()
            .frame(width: geometry.size.width - 32)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }

    private func iconBasedOnStatus() -> String {
        switch progressStatus {
            case "Done":
                return "checkmark"
            case "Failed":
                return "xmark"
            default:
                return "circle"
            }
        }
    }
