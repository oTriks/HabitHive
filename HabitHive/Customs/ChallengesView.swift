
import SwiftUI

struct ChallengesView: View {
    let streaks: Int
    
    var body: some View {
        HStack(spacing: 1) {
            ForEach(1...5, id: \.self) { index in
                let isUnlocked = streaks >= streakNeeded(for: index)
                let imageName = isUnlocked ? "medal_\(streakNeeded(for: index))" : "medal_locked"
                ChallengeIcon(isUnlocked: isUnlocked, imageName: imageName)
                    .frame(width: 80, height: 80)
                
            }
        }
        .padding()
    }
    
    private func streakNeeded(for index: Int) -> Int {
        switch index {
        case 1: return 1
        case 2: return 3
        case 3: return 7
        case 4: return 14
        case 5: return 30
        default: return 0
        }
    }
    
}



struct ChallengeIcon: View {
    let isUnlocked: Bool
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(isUnlocked ? .green : .gray)
            .padding()
    }
}

struct ChallengesView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesView(streaks: 5)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
