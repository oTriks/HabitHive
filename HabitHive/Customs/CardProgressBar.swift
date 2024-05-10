import SwiftUI

struct CardProgressBar: View {
    let progress: [String: String]
    let startDate: Date
    let endDate: Date
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth: CGFloat = 100
            let doneWidth = min(totalWidth * CGFloat(calculateDonePercentage()), totalWidth)
            let pendingWidth = totalWidth - doneWidth
            
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color("Positive"))
                    .frame(width: doneWidth)
                
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: pendingWidth)
            }
            .cornerRadius(4)
            .frame(width: totalWidth, height: 8)
            .alignmentGuide(.trailing) { _ in
                geometry.size.width
            }
        }
        .frame(width: 100, height: 8)
    }
    
    private func calculateDonePercentage() -> CGFloat {
        let doneCount = progress.values.filter { $0 == "Done" }.count
        let totalCount = progress.count
        return CGFloat(doneCount) / CGFloat(totalCount)
    }
}
