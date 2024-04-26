import SwiftUI

struct ProgressHabitCardView: View {
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
                
                
                
            }
        }
    }
}

struct ProgressHabitCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressHabitCardView(habit: Habit.sampleHabit)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
