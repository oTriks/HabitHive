import SwiftUI

struct CardProgressBar: View {
    let progress: [String: String] // Progress map of the habit
    let totalDays: Int
    
    var body: some View {
        GeometryReader { geometry in
            let progressData = calculateProgress()
            let totalWidth = geometry.size.width
            let doneWidth = totalWidth * CGFloat(progressData.donePercentage)
            let pendingWidth = totalWidth * CGFloat(progressData.pendingPercentage)

            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: doneWidth)

                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: pendingWidth)
            }
            .cornerRadius(4)
            .frame(height: 8) // Adjust the height of the bar
        }
        .frame(height: 8) // Adjust the height of the bar
    }
    
    // Calculate the progress percentages for "Done" and "Pending/Failed."
    private func calculateProgress() -> (donePercentage: Double, pendingPercentage: Double) {
        let doneCount = progress.values.filter { $0 == "Done" }.count
        let failedPendingCount = progress.values.filter { $0 == "Pending" || $0 == "Failed" }.count

        let donePercentage = Double(doneCount) / Double(totalDays)
        let pendingPercentage = Double(failedPendingCount) / Double(totalDays)

        return (donePercentage: donePercentage, pendingPercentage: pendingPercentage)
    }
}



