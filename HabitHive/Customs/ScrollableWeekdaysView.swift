import SwiftUI

struct ScrollableWeekdaysView: View {
    var currentDate: Date
    var daysOfWeek: [String]
    var progressMap: [String: String] // Accepting progress data

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Spacer()
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    let day = dateForWeekday(dayName: daysOfWeek[index])
                    let dateString = formatter.string(from: day)
                    let progress = progressMap[dateString] ?? "Unknown"
                    VStack {
                        Text(daysOfWeek[index].prefix(1))
                            .frame(width: 28, alignment: .center)
                        Text(formatter.string(from: day))
                            .frame(width: 28, alignment: .center)
                        Text(progress)
                            .font(.caption)
                            .foregroundColor(progressColor(for: progress))
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

    private func progressColor(for status: String) -> Color {
        switch status {
        case "Done":
            return .green
        case "Failed":
            return .red
        default:
            return .gray
        }
    }
}
