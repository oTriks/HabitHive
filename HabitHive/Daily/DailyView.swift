import SwiftUI

struct DailyView: View {
    @ObservedObject var viewModel = DailyViewModel()
    
    @State private var selectedDate = Date()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())], spacing: 20) {
                    ForEach(Date().daysInRange(from: -30, to: 30), id: \.self) { date in
                        VStack {
                            Text(dateFormatter.string(from: date))
                                .font(.headline)
                            Text("\(date.day)")
                                .font(.subheadline)
                        }
                        .padding()
                        .background(selectedDate.isSameDay(as: date) ? Color.blue : Color.clear)
                        .foregroundColor(selectedDate.isSameDay(as: date) ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            selectedDate = date
                        }
                    }
                }
                .padding()
            }
            
            // Habit cards
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.habits, id: \.id) { habit in
                        DailyHabitCardView(habit: habit)
                    }
                }
                .padding()
            }
        }
    }
}

extension Date {
    func daysInRange(from startOffset: Int, to endOffset: Int) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: startOffset, to: self)!
        let endDate = calendar.date(byAdding: .month, value: endOffset, to: self)!
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = DailyViewModel()
        viewModel.habits = [Habit.sampleHabit]
        
        return DailyView(viewModel: viewModel)
    }
}

// Habit model and ViewModel remain unchanged
