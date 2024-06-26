import SwiftUI

struct ProgressHabitCardView: View {
    var habit: Habit
    @State private var isSelected = false
    
    var body: some View {
        GeometryReader { geometry in
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
                
                CardProgressBar(
                    progress: habit.progress ?? [:],
                    startDate: habit.startDate,
                    endDate: habit.endDate
                )
                .frame(width: 100)
            }
            .padding()
            .frame(width: geometry.size.width - 32)
            .background(Color("Color primary"))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }
}
