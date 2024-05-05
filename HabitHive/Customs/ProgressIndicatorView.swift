import SwiftUI

struct ProgressIndicatorView: View {
    var startDate: Date   // Starting date of the habit.
    var endDate: Date     // End date of the habit.
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    // Calculate total duration in days between startDate and endDate
    private var totalDuration: Double {
        max(endDate.timeIntervalSince(startDate) / 86400, 1)
    }

    // Calculate how many days have passed since the start date up to now
    private var elapsedDays: Double {
        max(Date().timeIntervalSince(startDate) / 86400, 0)
    }

    // Calculate the progress ratio based on elapsed days
    private var progress: Double {
        min(elapsedDays / totalDuration, 1) // Clamp to a range of 0 to 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(Int(elapsedDays)) / \(Int(totalDuration)) days")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Total duration bar (background)
                    Rectangle()
                        .frame(width: geometry.size.width, height: 20)
                        .foregroundColor(Color.yellow.opacity(0.6))
                        .cornerRadius(10)

                    // Elapsed duration bar (foreground)
                    Rectangle()
                        .frame(width: CGFloat(progress) * geometry.size.width, height: 20)
                        .foregroundColor(Color.green)
                        .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                }
            }
            .frame(height: 20)

            // Adding date labels underneath the bar
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


// Custom corner radius modifier
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Example of a preview provider
struct ProgressIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        let startDate = Calendar.current.date(from: DateComponents(year: 2024, month: 5, day: 1))!
        let endDate = Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 1))!

        ProgressIndicatorView(startDate: startDate, endDate: endDate)
            .frame(height: 100)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
