import SwiftUI

struct DailyView: View {
    @ObservedObject var viewModel = DailyViewModel()
    @State private var selectedDate = Date()
    @State private var isShowingAwardPopup = false

    @State private var achievedStreak = 0

    var body: some View {
        NavigationView {
            VStack {
                ScrollDaysView(
                    startDate: Date().addingTimeInterval(-60 * 24 * 60 * 60),
                    endDate: Date().addingTimeInterval(60 * 24 * 60 * 60),
                    selectedDate: $selectedDate
                )
                
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.filteredHabits(for: selectedDate), id: \.habit.id) { (habit, progressStatus) in
                            DailyHabitCardView(
                                                            viewModel: viewModel,
                                                            habit: habit,
                                                            progressStatus: progressStatus,
                                                            selectedDate: selectedDate,  onStreakAchieved: { milestone in
                                                                achievedStreak = milestone
                                                                isShowingAwardPopup = true
                                                            }
                                                        )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowingAwardPopup) {
                            AwardPopupView(streak: achievedStreak)
                        }
            .onAppear {
                viewModel.fetchHabits()
                selectedDate = Date()
            }
        }
    }
}

extension DailyViewModel {
    func filteredHabits(for date: Date) -> [(habit: Habit, progressStatus: String?)] {
        let dateString = formatDate(date)
        return habits.compactMap { habit in
            if habit.dailyMap?[dateString] ?? false {
                let progressStatus = habit.progress?[dateString] ?? nil
                return (habit: habit, progressStatus: progressStatus)
            }
            return nil
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleHabits = [
            Habit(
                id: "1",
                name: "Morning Run",
                description: "Running around the park",
                frequency: "Daily",
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
                daysOfWeek: ["Monday", "Wednesday", "Friday"],
                progress: ["2024-05-05": "Completed"],
                userID: "User1",
                dailyMap: ["2024-05-05": true]
            ),
            Habit(
                id: "2",
                name: "Read Book",
                description: "Read a chapter daily",
                frequency: "Daily",
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
                daysOfWeek: ["Tuesday", "Thursday"],
                progress: ["2024-05-05": "Skipped", "2024-05-06": "Completed"],
                userID: "User1",
                dailyMap: ["2024-05-05": true, "2024-05-06": true]
            ),
            Habit(
                id: "3",
                name: "Drink Water",
                description: "Stay hydrated",
                frequency: "Daily",
                startDate: Date(),
                endDate: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date(),
                daysOfWeek: ["Saturday", "Sunday"],
                progress: ["2024-05-05": "Missed", "2024-05-06": "Completed"],
                userID: "User1",
                dailyMap: ["2024-05-05": false, "2024-05-06": true]
            )
        ]
        
        let mockViewModel = DailyViewModel()
        mockViewModel.habits = sampleHabits
        
        return DailyView(viewModel: mockViewModel)
    }
}
