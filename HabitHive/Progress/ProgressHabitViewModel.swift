import Foundation

class ProgressHabitViewModel: ObservableObject {
    @Published var doneCount = 0
    @Published var failedCount = 0
    @Published var pendingCount = 0

    @Published var currentStreak = 0
       @Published var bestStreak = 0
    @Published var challengeStreaks: [Int] = [1, 3, 7, 14, 30] // Array of streaks needed for challenges

    func calculateStatistics(for habit: Habit) {
        guard let progress = habit.progress else {
            doneCount = 0
            failedCount = 0
            pendingCount = 0
            return
        }

        var done = 0
        var failed = 0
        var pending = 0

        // Count based on the "progress" dictionary values
        for (_, status) in progress {
            switch status {
                case "Done":
                    done += 1
                case "Failed":
                    failed += 1
                case "Pending":
                    pending += 1
                default:
                    break
            }
        }

        // Update the published properties
        doneCount = done
        failedCount = failed
        pendingCount = pending
    }
}



// Function to calculate time-based progress
   private func calculateTimeProgress(startDate: Date, endDate: Date) -> Double {
       // Total duration in days between startDate and endDate
       let totalDuration = max(endDate.timeIntervalSince(startDate) / 86400, 1)

       // Days elapsed from the start date to today
       let elapsedDays = max(Date().timeIntervalSince(startDate) / 86400, 0)

       // Calculate the progress ratio (clamp between 0 and 1)
       return min(elapsedDays / totalDuration, 1)
   }


private func calculateCurrentStreak(for habit: Habit) -> Int {
    guard let progress = habit.progress else {
        return 0
    }

    let sortedProgress = progress.sorted(by: { $0.key > $1.key })
    var currentStreak = 0

    for (_, status) in sortedProgress {
        if status == "Done" {
            currentStreak += 1
        } else {
            break
        }
    }

    return currentStreak
}

private func calculateBestStreak(for habit: Habit) -> Int {
    guard let progress = habit.progress else {
        return 0
    }

    let sortedProgress = progress.sorted(by: { $0.key < $1.key })
    var bestStreak = 0
    var currentStreak = 0

    for (_, status) in sortedProgress {
        if status == "Done" {
            currentStreak += 1
            bestStreak = max(bestStreak, currentStreak)
        } else {
            currentStreak = 0
        }
    }

    return bestStreak
}




