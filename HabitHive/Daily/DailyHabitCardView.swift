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
                        .fixedSize(horizontal: false, vertical: true)


                    Text(habit.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 2)
                .frame(width: 300) 
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                Button(action: {
                    isSelected.toggle()
                }) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 48, height: 48)
                        .padding(10)
                        .overlay(
                            Image(systemName: isSelected ? "checkmark" : "xmark")
                                .foregroundColor(.white)
                        )
                }
                .padding(.trailing)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity) // Expand the card to full screen width
    }
}

struct DailyHabitCardView_Previews: PreviewProvider {
    static var previews: some View {
        DailyHabitCardView(habit: Habit.sampleHabit)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
