import SwiftUI

struct BarGraphView: View {
    var habitData: [String: Int] // Dictionary containing habit completion data for each month
    private let months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]

    var body: some View {
        VStack {
            // Bar Graph with months' data
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<months.count, id: \.self) { index in
                    VStack {
                        // Calculate bar height based on habit completion count for the month
                        let completionCount = habitData[months[index]] ?? 0
                        let barHeight = CGFloat(completionCount) / 31 * 200 // 31 is the maximum value for a month
                        
                        // Create a bar for each month
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 20, height: barHeight)

                        // Month abbreviation label
                        Text(months[index])
                            .font(.caption)
                            .foregroundColor(.primary)
                        
                        // Completion count label above the bar
                        Text("\(completionCount)")
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding(.top, 2)
                    }
                }
            }
        }
        .padding()
    }
}

// Preview Provider for the BarGraphView
struct BarGraphView_Previews: PreviewProvider {
    static var previews: some View {
        // Example habit data representing completions for each month
        let habitData: [String: Int] = [
            "Jan": 15, "Feb": 20, "Mar": 10, "Apr": 25,
            "May": 12, "Jun": 18, "Jul": 22, "Aug": 14,
            "Sep": 8, "Oct": 17, "Nov": 19, "Dec": 23
        ]
        
        BarGraphView(habitData: habitData)
            .frame(width: 400, height: 300) // Adjust the size as needed
    }
}
