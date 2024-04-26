import SwiftUI

struct ScrollableWeekdaysView: View {
    var currentDate: Date
    var daysOfWeek: [String]  // Example: ["Monday", "Wednesday", "Friday"]

    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"  // "1" for the day of the month
        return f
    }()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Spacer()
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    let day = dateForWeekday(dayName: daysOfWeek[index])
                    VStack {
                        Text(daysOfWeek[index].prefix(1))  // "M", "W", "F"
                            .frame(width: 28, alignment: .center)
                        Text(formatter.string(from: day))
                            .frame(width: 28, alignment: .center)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .frame(height: 60)
    }

    private func dateForWeekday(dayName: String) -> Date {
        guard let weekday = DateFormatter().weekdaySymbols.firstIndex(of: dayName) else { return currentDate }
        let calendar = Calendar.current
        return calendar.nextDate(after: currentDate, matching: DateComponents(weekday: weekday + 1), matchingPolicy: .nextTime)!
    }
}
