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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        self.dataLoaded = true
                    }
                }
            }
        }
        .frame(height: 60)
    }
    
    
    private func scrollToCurrentDate(using scrollViewProxy: ScrollViewProxy) {
        let currentDayString = formatter.string(from: currentDate)
        
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
        formatter.dateFormat = "E"
        return formatter
    }()
    
    private var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text(weekdayFormatter.string(from: date).prefix(1))
                .font(.headline)
                .frame(width: 28, alignment: .center)
            
            Text(dayFormatter.string(from: date))
                .font(.caption)
                .frame(width: 28, height: 28, alignment: .center)
                .background(background(for: progress))
                .border(borderColor(for: progress), width: 2)
                .cornerRadius(4)
                .foregroundColor(textColor(for: progress))
                .onTapGesture {
                    updateProgress()
                }
        }
    }
    
    private func background(for status: String) -> Color {
        switch status {
        case "Done":
            return Color("Positive")
        case "Failed":
            return Color("Negative")
        default:
            return .clear
        }
    }
    
    private func borderColor(for status: String) -> Color {
        switch status {
        case "Pending":
            return Color("silver background")
        default:
            return .clear
        }
    }
    
    private func textColor(for status: String) -> Color {
        switch status {
        case "Done", "Failed":
            return .white
        default:
            return Color("Text primary")  
        }
    }
}
