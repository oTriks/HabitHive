import SwiftUI

struct DebugCurrentDateView: View {
    let currentDate: Date = Date()
    
    var body: some View {
        Text("Current Date: \(formattedDate)")
            .onAppear {
                print("Current Date: \(formattedDate)")
            }
    }

    private var formattedDate: String {
        DateFormatter.iso8601Full.string(from: currentDate)
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) 
        return formatter
    }()
}

struct DebugCurrentDateView_Previews: PreviewProvider {
    static var previews: some View {
        DebugCurrentDateView()
    }
}
