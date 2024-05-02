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
            }
            .padding()
            .frame(width: geometry.size.width - 32)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
    }
}


