import SwiftUI

struct CalendarView: View {
    var habitID: String
    @ObservedObject var viewModel: HabitsViewModel
    @State private var selectedDate: Date = Date()
    @State private var habitProgress: [String: String] = [:]

    var body: some View {
        VStack {
            Text("Calendar View for \(habitID)")
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .onChange(of: selectedDate) { newValue in
                    viewModel.updateProgress(for: habitID, date: formatDate(newValue))
                }

            CustomCalendar(selectedDate: $selectedDate, habitProgress: habitProgress)
        }
        .onAppear {
            fetchHabitProgress()
        }
    }

    private func fetchHabitProgress() {
        if let habit = viewModel.habits.first(where: { $0.id == habitID }), let progress = habit.progress {
            habitProgress = progress
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct CustomCalendar: View {
    @Binding var selectedDate: Date
    var habitProgress: [String: String]

    var body: some View {
        VStack {
            Text(monthYearString(from: selectedDate))
                .font(.title)
                .padding(.vertical)

            CalendarGridView(selectedDate: $selectedDate, habitProgress: habitProgress)
        }
    }

    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    var habitProgress: [String: String]

    var body: some View {
        VStack {
            HStack {
                ForEach(1 ..< 8) { index in
                    Text(weekdayAbbreviation(from: Date().addingTimeInterval(TimeInterval(index * 24 * 3600))))
                        .font(.headline)
                        .padding(.vertical, 4)
                }
            }

            VStack {
                ForEach(monthDates(for: selectedDate), id: \.self) { weekDates in
                    HStack {
                        ForEach(weekDates, id: \.self) { date in
                            DateCell(date: date, isSelected: isDateSelected(date), progressStatus: progressStatus(for: date))
                                .padding(4)
                        }
                    }
                }
            }
        }
    }

    private func weekdayAbbreviation(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

    private func monthDates(for date: Date) -> [[Date]] {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .weekday], from: date)

        components.day = 1
        let startOfMonth = calendar.date(from: components)!

        components.month! += 1
        components.day! -= 1
        let endOfMonth = calendar.date(from: components)!

        var monthDates: [[Date]] = []
        var weekDates: [Date] = []
        var currentDate = startOfMonth

        while currentDate <= endOfMonth {
            if calendar.isDate(currentDate, equalTo: startOfMonth, toGranularity: .month) {
                weekDates.append(currentDate)
            } else {
                monthDates.append(weekDates)
                weekDates = [currentDate]
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        monthDates.append(weekDates)
        return monthDates
    }

    private func isDateSelected(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }

    private func progressStatus(for date: Date) -> String? {
        let dateString = formatDate(date)
        return habitProgress[dateString]
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

struct DateCell: View {
    var date: Date
    var isSelected: Bool
    var progressStatus: String?

    var body: some View {
        Text("\(date.day)")
            .font(.body)
            .frame(width: 30, height: 30)
            .background(isSelected ? Color.blue : (progressStatus == "Done" ? Color.green : Color.clear)) 
            .clipShape(Circle())
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.vertical, 4)
            .overlay(
                Text(progressStatus ?? "")
                    .foregroundColor(.white)
                    .font(.caption)
            )
    }
}



private extension Date {
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
}

