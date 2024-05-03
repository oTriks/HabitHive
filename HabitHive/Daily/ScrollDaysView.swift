import SwiftUI

struct ScrollDaysView: View {
    var startDate: Date
    var endDate: Date
    var selectedDate: Binding<Date>
    @State private var scrollViewProxy: ScrollViewProxy?
    
    private var dates: [Date] {
        var currentDate = startDate
        var dateArray = [Date]()
        while currentDate <= endDate {
            dateArray.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dateArray
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 10) {
                    ForEach(dates, id: \.self) { date in
                        VStack(spacing: 10) {
                            Day2View(date: date, isSelected: selectedDate.wrappedValue == date)
                                .onTapGesture {
                                    selectedDate.wrappedValue = date
                                }
                                .id(date)
                        }
                    }
                }
                .padding(.bottom, 10)
                .onAppear {
                    scrollViewProxy = proxy
                    scrollToSelectedDate()
                    // Scroll to May 7th when the view appears
                    scrollToMay7th(using: proxy)
                }
                .onChange(of: selectedDate.wrappedValue) { _ in
                    scrollToSelectedDate()
                }
            }
        }
        .background(Color.blue)
    }
    
    private func scrollToSelectedDate() {
        guard let scrollViewProxy = scrollViewProxy,
              let index = dates.firstIndex(of: selectedDate.wrappedValue) else { return }
        
        withAnimation {
            scrollViewProxy.scrollTo(dates[index], anchor: .center)
        }
    }
    
    private func scrollToMay7th(using proxy: ScrollViewProxy?) {
        let desiredDate = Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 12)) // May 7th
        
        guard let desiredDate = desiredDate else { return }
        
        DispatchQueue.main.async {
            withAnimation {
                proxy?.scrollTo(desiredDate, anchor: .center)
            }
        }
    }
}

struct Day2View: View {
    var date: Date
    var isSelected: Bool
    
    public init(date: Date, isSelected: Bool) {
        self.date = date
        self.isSelected = isSelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Display "Mon, Apr" above
            Text(dayMonthFormatter.string(from: date))
                .font(.caption)
                .frame(width: 48, height: 28, alignment: .center)
                .foregroundColor(textColor)
            
            // Display the day number underneath
            Text(dayFormatter.string(from: date))
                .font(.headline)
                .frame(width: 48, alignment: .center)
                .background(background)
                .border(borderColor, width: 2)
                .cornerRadius(4)
                .foregroundColor(textColor)
        }
    }

    private var background: Color {
        isSelected ? Color.blue : Color.clear
    }

    private var borderColor: Color {
        isSelected ? Color.white : Color.clear
    }

    private var textColor: Color {
        isSelected ? Color.white : Color.black
    }

    private var dayMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM" // "Mon, Apr"
        return formatter
    }()

    private var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Day of the month as a number
        return formatter
    }()
}
