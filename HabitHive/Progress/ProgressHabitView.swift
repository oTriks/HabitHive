
import SwiftUI

struct ProgressHabitView: View {
    var habit: Habit
    @StateObject private var viewModel = ProgressHabitViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Display SuccessCircleView using calculated statistics
                SectionHeaderView(title: "Task Progress")
                HStack {
                    Spacer()
                    SuccessCircleView(doneCount: viewModel.doneCount, failedCount: viewModel.failedCount, pendingCount: viewModel.pendingCount)
                        .padding()
                    Spacer()
                }
                
                Divider()
                    .background(Color("Primary details"))
                
                // Example end date calculation (1 month after start date)
                SectionHeaderView(title: "Time-Based Progress")
                let endDate = Calendar.current.date(byAdding: .month, value: 1, to: habit.startDate) ?? Date()
                ProgressIndicatorView(
                    startDate: habit.startDate,
                    endDate: endDate
                )
                .padding()
                
                Divider()
                    .background(Color("Primary details"))
                
                SectionHeaderView(title: "Streaks")
                HStack {
                    VStack {
                        Text("Current")
                            .font(.headline)
                        Text("\(viewModel.currentStreak) days") // Replace with the actual streak count
                            .font(.title)
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack {
                        Text("Best")
                            .font(.headline)
                        Text("\(viewModel.bestStreak) days") // Replace with the actual streak count
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                Divider()
                    .background(Color("Primary details"))
                
                
                
            }
            SectionHeaderView(title: "Challenges")
            ChallengesView(streaks: viewModel.bestStreak)

            .navigationBarTitle(Text(habit.name), displayMode: .inline)
            .onAppear {
                // Calculate statistics for the given habit
                viewModel.calculateStatistics(for: habit)
            }
        }
    }
}



// Simple Section Header View
struct SectionHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top)
    }
}


