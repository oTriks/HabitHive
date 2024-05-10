import Foundation

class ProgressHabitViewModel: ObservableObject {
    @Published var doneCount = 0
    @Published var failedCount = 0
    @Published var pendingCount = 0
    @Published var currentStreak = 0
    @Published var bestStreak = 0
    @Published var challengeStreaks: [Int] = [1, 3, 7, 14, 30]
    @Published var habitEndDate: Date = Date()

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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let habitStartDay = calendar.startOfDay(for: habit.startDate)
        let today = calendar.startOfDay(for: Date())
        
        for (dateString, status) in progress {
            if let date = dateFormatter.date(from: dateString), date >= habitStartDay && date <= today {
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
        }
        
        doneCount = done
        failedCount = failed
        pendingCount = pending
        currentStreak = calculateCurrentStreak(for: habit, dateFormatter: dateFormatter)
        bestStreak = calculateBestStreak(for: habit, dateFormatter: dateFormatter)
    }
    
    
    func getMonthlyHabitData(for habit: Habit) -> [String: Int] {
        guard let progress = habit.progress else {
            return [:]
        }
        var monthlyData: [String: Int] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        for (dateString, status) in progress {
            if let date = dateFormatter.date(from: dateString) {
                if status == "Done" {
                    let monthString = monthFormatter.string(from: date)
                    
                    monthlyData[monthString, default: 0] += 1
                }
            } else {
            }
        }
        return monthlyData
    }
    
    private func calculateTimeProgress(startDate: Date, endDate: Date) -> Double {
        let totalDuration = max(endDate.timeIntervalSince(startDate) / 86400, 1)
        
        let elapsedDays = max(Date().timeIntervalSince(startDate) / 86400, 0)
        
        return min(elapsedDays / totalDuration, 1)
    }
    
    
    private func calculateCurrentStreak(for habit: Habit, dateFormatter: DateFormatter) -> Int {
        guard let progress = habit.progress else {
            return 0
        }
        
        let calendar = Calendar.current
        let habitStartDay = calendar.startOfDay(for: habit.startDate)
        let today = calendar.startOfDay(for: Date())
        
        let sortedProgress = progress.sorted(by: { $0.key > $1.key })
        var currentStreak = 0
        
        for (dateString, status) in sortedProgress {
            if let date = dateFormatter.date(from: dateString), date <= today && date >= habitStartDay {
                if status == "Done" {
                    currentStreak += 1
                } else {
                    break
                }
            }
        }
        
        return currentStreak
    }
    
    private func calculateBestStreak(for habit: Habit, dateFormatter: DateFormatter) -> Int {
        guard let progress = habit.progress else {
            return 0
        }
        
        let calendar = Calendar.current
        let habitStartDay = calendar.startOfDay(for: habit.startDate)
        let today = calendar.startOfDay(for: Date())
        let sortedProgress = progress.sorted(by: { $0.key < $1.key })
        var bestStreak = 0
        var currentStreak = 0
        
        for (dateString, status) in sortedProgress {
            if let date = dateFormatter.date(from: dateString), date <= today && date >= habitStartDay {
                if status == "Done" {
                    currentStreak += 1
                    bestStreak = max(bestStreak, currentStreak)
                } else {
                    currentStreak = 0
                }
            }
        }
        
        return bestStreak
    }
}


