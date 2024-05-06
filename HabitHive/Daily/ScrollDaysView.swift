import SwiftUI

struct ScrollDaysView: View {
    var startDate: Date
    var endDate: Date
    @Binding var selectedDate: Date

    private var dates: [Date] {
        var currentDate = startDate
        var dateArray = [Date]()
        while currentDate <= endDate {
            let startOfDay = Calendar.current.startOfDay(for: currentDate) // Normalize to start of day
            dateArray.append(startOfDay)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dateArray
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 10) {
                    ForEach(dates, id: \.self) { date in
                        Day2View(date: date, isSelected: Calendar.current.isDate(selectedDate, inSameDayAs: date))
                            .id(date)
                            .onTapGesture {
                                let startOfDay = Calendar.current.startOfDay(for: date) // Normalize tapped date
                                selectedDate = startOfDay
                                withAnimation {
                                    proxy.scrollTo(startOfDay, anchor: .center)
                                }
                            }
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    let startOfDay = Calendar.current.startOfDay(for: selectedDate) // Normalize initially selected date
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            proxy.scrollTo(startOfDay, anchor: .center)
                        }
                    }
                }
                .onChange(of: selectedDate) { newValue in
                    let startOfDay = Calendar.current.startOfDay(for: newValue) // Normalize changed date
                    DispatchQueue.main.async {
                        withAnimation {
                            proxy.scrollTo(startOfDay, anchor: .center)
                        }
                    }
                }
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
                Text(dayMonthFormatter.string(from: date))
                    .font(.caption)
                
                Text(dayFormatter.string(from: date))
                    .font(.headline)
            }
            .frame(width: 35, alignment: .center)
            .padding(4)
            .background(isSelected ? Color("button") : Color.clear)
            .cornerRadius(14)  // Rounded corners for the background
            .foregroundColor(isSelected ? Color("Text primary") : Color("Text trailing"))
        }

        private var dayMonthFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM"
            return formatter
        }()

        private var dayFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "d"
            return formatter
        }()
    }
