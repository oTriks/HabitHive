import SwiftUI

struct DailyView: View {
    @ObservedObject var viewModel = DailyViewModel()
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollDaysView(startDate: Date().addingTimeInterval(-60 * 24 * 60 * 60), // Start 60 days earlier
                               endDate: Date().addingTimeInterval(60 * 24 * 60 * 60),    // End 60 days later
                               selectedDate: $selectedDate)
                
                ScrollView {
                    LazyVStack(spacing: 95) {
                        ForEach(viewModel.filteredHabits(for: selectedDate), id: \.id) { habit in
                            DailyHabitCardView(habit: habit)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchHabits()
                selectedDate = Date()
            }
        }
    }
}

extension DailyViewModel {
    func filteredHabits(for date: Date) -> [Habit] {
        let dateString = formatDate(date)
        return habits.filter { habit in
            habit.dailyMap?[dateString] ?? false
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" 
        return formatter.string(from: date)
    }
}


    
  

