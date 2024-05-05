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
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(habit.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    
                }
                
                CardProgressBar(
                                    progress: habit.progress ?? [:],
                                    startDate: habit.startDate,
                                    endDate: habit.endDate
                                )
                                .frame(width: geometry.size.width - 200)
                
                
            
            }
            .padding()
            .frame(width: geometry.size.width - 32)
            .background(Color("Primary"))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }
    
    private func calculateTotalDays(for habit: Habit) -> Int {
           let calendar = Calendar.current
           return calendar.dateComponents([.day], from: habit.startDate, to: habit.endDate).day ?? 0
       }
    
}


