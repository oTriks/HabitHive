import SwiftUI

struct BarGraphView: View {
    var habitData: [String: Int]
    private let months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]
    
    var maxCount: Int {
        habitData.values.max() ?? 1
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<months.count, id: \.self) { index in
                    VStack {
                        let completionCount = habitData[months[index]] ?? 0
                        let barHeight = CGFloat(completionCount) / CGFloat(maxCount) * 200
                        
                        Text("\(completionCount)")
                            .font(.caption)
                            .foregroundColor(.primary)
                            .padding(.bottom, 2)
                        
                        Rectangle()
                            .fill(Color("Positive"))
                            .frame(width: 20, height: barHeight)
                        
                        Text(months[index])
                            .font(.caption)
                            .foregroundColor(.primary)
                            .frame(width: 24)
                            .fixedSize(horizontal: true, vertical: false) 
                        
                    }
                }
            }
        }
        .padding()
    }
}


struct BarGraphView_Previews: PreviewProvider {
    static var previews: some View {
        let habitData: [String: Int] = [
            "Jan": 15, "Feb": 20, "Mar": 10, "Apr": 25,
            "May": 12, "Jun": 18, "Jul": 22, "Aug": 14,
            "Sep": 8, "Oct": 17, "Nov": 19, "Dec": 23
        ]
        
        BarGraphView(habitData: habitData)
            .frame(width: 400, height: 300)
    }
}
