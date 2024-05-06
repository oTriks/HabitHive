import SwiftUI

struct AwardPopupView: View {
    var streak: Int // This will hold the current streak count

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10) {
                    Text("Well done!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Positive"))

                    Image(medalName(for: streak))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Divider()
                        .background(Color("Positive"))

                    // Display the current streak count
                    VStack(spacing: 10) {
                        Text("Streak")
                        Text("\(streak) days")
                    }
                    .foregroundColor(Color("Positive"))
                    .fontWeight(.semibold)

                    Divider()
                        .background(Color("Positive"))

                    // Display the next milestone information
                    Text("Next award: \(nextMilestone(after: streak)) days")
                        .foregroundColor(Color("Text trailing"))

                    Divider()
                        .background(Color("Positive"))

                    Text("Close")
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Negative"))

                    Spacer()
                }
                .padding()
                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }

    // Function to return the correct medal name based on the streak count
    private func medalName(for streak: Int) -> String {
        switch streak {
        case 1:
            return "medal_1"
        case 3:
            return "medal_3"
        case 7:
            return "medal_7"
        case 14:
            return "medal_14"
        case 30:
            return "medal_30"
        default:
            return "medal_locked" // Provide a default medal image if needed
        }
    }

    // Function to determine the next milestone based on the current streak
    private func nextMilestone(after streak: Int) -> Int {
        if streak < 3 {
            return 3
        } else if streak < 7 {
            return 7
        } else if streak < 14 {
            return 14
        } else if streak < 30 {
            return 30
        } else {
            return streak // Or any other logic for streaks exceeding 30 days
        }
    }
}

struct AwardPopupView_Previews: PreviewProvider {
    static var previews: some View {
        AwardPopupView(streak: 3) // Adjust this to test different streaks
    }
}
