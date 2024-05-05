import SwiftUI

struct ScrollableWeekdaysView: View {
    var progressMap: [String: String]
    var currentDate: Date
    var habitId: String

    @State private var dataLoaded = false
    @ObservedObject var viewModel: HabitsViewModel

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // Get all dates available in the progress map
    private var dates: [Date] {
        progressMap.keys.compactMap { dateString in
            formatter.date(from: dateString)
        }.sorted()
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollViewProxy in
                LazyHStack(spacing: 10) {
                    ForEach(dates, id: \.self) { date in
                        let dateString = formatter.string(from: date)
                        let progress = progressMap[dateString] ?? "Unknown"
                        
                        DayView(date: date, progress: progress, updateProgress: {
                            viewModel.updateProgress(for: habitId, date: dateString)
                        })
                        .id(date)
                    }
                }
                .padding()
                .onChange(of: dataLoaded) { _ in
                    scrollToCurrentDate(using: scrollViewProxy)
                }
                .onAppear {
                    // Set a slight delay to ensure data is fully loaded
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.dataLoaded = true
                    }
                }
            }
        }
        .frame(height: 60)
    }

    
    private func scrollToCurrentDate(using scrollViewProxy: ScrollViewProxy) {
        // Format the current date to match the format of the progress map keys
        let currentDayString = formatter.string(from: currentDate)

        // Find the index of the current date within the sorted dates
        if let currentDateIndex = dates.firstIndex(where: { formatter.string(from: $0) == currentDayString }) {
            withAnimation {
                scrollViewProxy.scrollTo(dates[currentDateIndex], anchor: .center)
            }
        }
    }
}






struct DayView: View {
    var date: Date
    var progress: String
    var updateProgress: () -> Void

    
    public init(date: Date, progress: String, updateProgress: @escaping () -> Void) {
        self.date = date
        self.progress = progress
        self.updateProgress = updateProgress
    }

    private var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"  // "Sun, Mon, Tue, Wed, Thu, Fri, Sat"
        return formatter
    }()

    private var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"  // Day of the month as a number
        return formatter
    }()

    var body: some View {
        VStack {
            // Display the first character of the weekday, e.g., "S" for "Sunday"
            Text(weekdayFormatter.string(from: date).prefix(1))
                .font(.headline)
                .frame(width: 28, alignment: .center)
            
            // Display the day of the month in a square with status-specific background and border
            Text(dayFormatter.string(from: date))
                .font(.caption)
                .frame(width: 28, height: 28, alignment: .center)
                .background(background(for: progress))
                .border(borderColor(for: progress), width: 2) // Adding a border with specific width
                .cornerRadius(4)  // Slightly rounded corners for aesthetics
                .foregroundColor(textColor(for: progress))
                .onTapGesture {
                                    updateProgress()
                                }
        }
    }

    // Background color based on the progress status
    private func background(for status: String) -> Color {
        switch status {
        case "Done":
            return Color("Positive")
        case "Failed":
            return Color("Negative")
        default:
            return .clear  // No fill for "Pending"
        }
    }

    // Border color for the square around the day number
    private func borderColor(for status: String) -> Color {
        switch status {
        case "Pending":
            return Color("silver background")  // Gray border for "Pending"
        default:
            return .clear  // Clear border for other statuses
        }
    }

    // Text color based on the progress status
    private func textColor(for status: String) -> Color {
        switch status {
        case "Done", "Failed":
            return .white  // White text for contrast
        default:
            return Color("Text primary")  // Black text for visibility
        }
    }
}
