import SwiftUI

struct ProgressIndicatorView: View {
    var startDate: Date
    var endDate: Date

    
    
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    private var totalDuration: Double {
        max(endDate.timeIntervalSince(startDate) / 86400, 1)
    }

    private var elapsedDays: Double {
        max(Date().timeIntervalSince(startDate) / 86400, 0)
    }

    private var progress: Double {
        min(elapsedDays / totalDuration, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text("\(Int(elapsedDays)) / \(Int(totalDuration)) days")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 20)
                        .foregroundColor(Color.orange.opacity(0.6))
                        .cornerRadius(10)

                    Rectangle()
                        .frame(width: CGFloat(progress) * geometry.size.width, height: 20)
                        .foregroundColor(Color("Positive"))
                        .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .bottomLeft]))
                }
            }
            .frame(height: 20)

            HStack {
                Text(dateFormatter.string(from: startDate))
                Spacer()
                Text(dateFormatter.string(from: endDate))
            }
            .font(.caption)
        }
        .padding(.horizontal)
    }
}

struct ProgressIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        let startDate = Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 1))!
        let endDate = Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 31))!

        ProgressIndicatorView(startDate: startDate, endDate: endDate)
            .frame(height: 100)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
