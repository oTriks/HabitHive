

import Foundation
import SwiftUI

class DateUtilities {
    static let shared = DateUtilities()

    private init() {}

    func daysInRange(from startOffset: Int, to endOffset: Int, relativeTo date: Date) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: startOffset, to: date)!
        let endDate = calendar.date(byAdding: .day, value: endOffset, to: date)!
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    func isSameDay(_ date1: Date, as date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

struct FormatterConfig {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM"
        return formatter
    }()

    static let numberFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
}

struct DateView: View {
    let date: Date
    @Binding var selectedDate: Date
    
    var body: some View {
        ZStack {
            VStack {
                Text(FormatterConfig.dayFormatter.string(from: date))
                    .font(.headline)
                    .foregroundColor(selectedDate == date ? .white : .primary)
                
                Text(FormatterConfig.numberFormatter.string(from: date))
                    .font(.subheadline)
                    .foregroundColor(selectedDate == date ? .white : .primary)
            }
            .padding(.vertical, 6) // Adjust vertical padding
            .padding(.horizontal, 8) // Adjust horizontal padding
            .background(selectedDate == date ? Color.blue : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { }
                .zIndex(1) 
        }
        .onTapGesture {
            selectedDate = date
        }
    }
}





