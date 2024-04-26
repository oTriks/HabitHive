import SwiftUI

struct DailyHabitCardView: View {
    var habit: Habit
    @State private var isSelected = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(habit.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(habit.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading) // Expand the card horizontally
                
                Spacer() // Spacer to push the circle to the right edge
                
                Button(action: {
                    isSelected.toggle()
                }) {
                    Circle()
                        .fill(Color.blue) // Customize circle color
                        .frame(width: 48, height: 48) // Customize circle size
                        .padding(10) // Add padding around the circle
                        .overlay(
                            Image(systemName: isSelected ? "checkmark" : "xmark")
                                .foregroundColor(.white)
                        )
                }
            }
        }
    }
}

struct DailyHabitCardView_Previews: PreviewProvider {
    static var previews: some View {
        DailyHabitCardView(habit: Habit.sampleHabit)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
