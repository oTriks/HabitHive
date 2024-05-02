import SwiftUI

struct ProgressHabitCardView: View {
    let habitName: String
    let habitDescription: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                Text(habitName)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left edge

                Text(habitDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left edge

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

struct ProgressHabitCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressHabitCardView(habitName: "Exercise", habitDescription: "Go for a run or hit the gym")
            .padding()
    }
}
