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
                        VStack(spacing: 10) {
                            ForEach(viewModel.filteredHabits(for: selectedDate), id: \.habit.id) { (habit, progressStatus) in
                                DailyHabitCardView(
                                    viewModel: viewModel,
                                    habit: habit,
                                    progressStatus: progressStatus,
                                    selectedDate: selectedDate,
                                    onStreakAchieved: { milestone in
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
                .overlay(
                    Group {
                        if isShowingAwardPopup {
                            AwardPopupView(isShowing: $isShowingAwardPopup, streak: achievedStreak)
                                .transition(.opacity)
                                .animation(.easeInOut, value: isShowingAwardPopup)
                        }
                    }
                )
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
    
     func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

