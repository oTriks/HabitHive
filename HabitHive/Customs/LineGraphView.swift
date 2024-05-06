import SwiftUI

struct LineGraphView: View {
    let currentMonthDates: [String]
    var completionStatus: [String: String]
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(currentMonthDates, id: \.self) { date in
                    VStack(spacing: 0) {
                        Text(date)
                            .font(.caption)
                            .padding(.top, 8)
                        
                        if let status = completionStatus[date] {
                            if status == "Done" {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else if status == "Failed" {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        } else {
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .padding(.horizontal, 2)
                    .frame(width: 50)
                }
            }
            .frame(height: 150)
            .padding(.top, 8)
            .background(Color.gray.opacity(0.1))
            
            LineGraph(data: [0.2, 0.4, 0.6, 0.8, 0.5, 0.3, 0.7, 0.9])
                .frame(height: 150)
                .padding(.top, 8)
        }
        .padding()
    }
}

struct LineGraph: View {
    var data: [Double] 
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let widthFactor = geometry.size.width / CGFloat(data.count - 1)
                let height = geometry.size.height
                
                path.move(to: CGPoint(x: 0, y: height - (CGFloat(data[0]) * height)))
                
                for idx in data.indices {
                    let x = CGFloat(idx) * widthFactor
                    let y = height - (CGFloat(data[idx]) * height)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(Color.red, lineWidth: 2)
            .scaledToFit()
        }
    }
}

struct LineGraphView_Previews: PreviewProvider {
    static var previews: some View {
        let currentMonthDates = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
        let completionStatus = ["01": "Done", "03": "Failed", "05": "Done", "08": "Failed", "12": "Done", "15": "Failed", "18": "Done", "21": "Failed", "24": "Done", "27": "Failed", "30": "Done"]
        
        return LineGraphView(currentMonthDates: currentMonthDates, completionStatus: completionStatus)
    }
}
