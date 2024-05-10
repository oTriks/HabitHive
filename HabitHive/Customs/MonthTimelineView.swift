import SwiftUI

extension Date {
    func dayNumber() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        return "\(day)"
    }
}

struct MonthTimelineView: View {
    var habit: Habit
    
    var body: some View {
        HStack {
            ForEach(monthDates(), id: \.self) { date in
                VStack {
                    if let progress = habit.progress?[date.dayNumber()] {
                        if progress == "Done" {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        } else if progress == "Failed" {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                        }
                    } else {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.gray)
                    }
                    Text("\(date.dayNumber())")
                        .font(.caption)
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func monthDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: habit.startDate)
        guard let endDate = calendar.date(byAdding: .month, value: 1, to: startDate) else { return [] }
        return generateDates(inside: startDate ..< endDate, matching: [.day], matchingPolicy: .nextTime)!
    }
    
    private func generateDates(inside range: Range<Date>, matching components: Set<Calendar.Component>, matchingPolicy: Calendar.MatchingPolicy, repeatedTime: DateComponents? = nil) -> [Date]? {
        var dates: [Date] = []
        var currentDate = range.lowerBound
        
        while currentDate < range.upperBound {
            dates.append(currentDate)
            guard let newDate = Calendar.current.date(byAdding: repeatedTime ?? DateComponents(day: 1), to: currentDate) else { return nil }
            currentDate = newDate
        }
        
        return dates
    }
}


