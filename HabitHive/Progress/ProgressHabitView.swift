import SwiftUI

struct ProgressHabitView: View {
    var habit: Habit
    @StateObject private var viewModel = ProgressHabitViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeaderView(title: "Progress")
                HStack {
                    Spacer()
                    SuccessCircleView(doneCount: viewModel.doneCount, failedCount: viewModel.failedCount, pendingCount: viewModel.pendingCount)
                        .padding()
                        .padding()
                        .frame(maxWidth: .infinity) 
                    
                    Spacer()
                }
                
                Divider().background(Color("Primary details"))
                
                SectionHeaderView(title: "Time completion")
                let endDate = Calendar.current.date(byAdding: .month, value: 1, to: habit.startDate) ?? Date()
                ProgressIndicatorView(
                    startDate: habit.startDate,
                    endDate: endDate
                )
                .padding()
                
                Divider().background(Color("Primary details"))
                
                SectionHeaderView(title: "Streaks")
                HStack {
                    VStack {
                        Text("Current")
                            .font(.headline)
                        Text("\(viewModel.currentStreak) days")
                            .font(.title)
                            .foregroundColor(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack {
                        Text("Best")
                            .font(.headline)
                        Text("\(viewModel.bestStreak) days")
                            .font(.title)
                            .foregroundColor(Color("Positive"))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                
                Divider().background(Color("Primary details"))
                
                SectionHeaderView(title: "Monthly Progress")
                BarGraphView(habitData: viewModel.getMonthlyHabitData(for: habit))
                    .frame(height: 200)
                    .padding()
                
                Divider().background(Color("Primary details"))
                
                SectionHeaderView(title: "Challenges")
                ChallengesView(streaks: viewModel.bestStreak)
                
                    .navigationBarTitle(Text(habit.name), displayMode: .inline)
                    .onAppear {
                        viewModel.calculateStatistics(for: habit)
                    }
            }
        }
    }
}



struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top)
    }
}


