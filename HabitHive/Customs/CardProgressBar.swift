import SwiftUI

struct CardProgressBar: View {
    let progress: [String: String] // Progress map of the habit
    let startDate: Date
    let endDate: Date

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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Create a date range using start and end dates
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: startDate)
        let endDay = calendar.startOfDay(for: min(endDate, Date()))

        // Filter progress based on the desired range
        let filteredProgress = progress.filter { key, _ in
            if let date = dateFormatter.date(from: key) {
                return date >= startDay && date <= endDay
            }
            return false
        }

        // Calculate counts for "Done" and "Pending/Failed"
        let doneCount = filteredProgress.values.filter { $0 == "Done" }.count
        let failedPendingCount = filteredProgress.values.filter { $0 == "Pending" || $0 == "Failed" }.count
        let totalDays = Double(calendar.dateComponents([.day], from: startDay, to: endDay).day ?? 0)

        let donePercentage = Double(doneCount) / totalDays
        let pendingPercentage = Double(failedPendingCount) / totalDays

        return (donePercentage: donePercentage, pendingPercentage: pendingPercentage)
    }
}
