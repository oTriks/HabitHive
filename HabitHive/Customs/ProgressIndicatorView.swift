import SwiftUI

struct ProgressIndicatorView: View {
    var progress: Double  // The fraction of the period completed successfully.
    var startDate: Date   // Starting date of the habit.
    var endDate: Date     // End date of the habit.
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Adjust the date format as needed
        return formatter
    }
    
    private var totalDuration: Double {
        // Calculate the total days from the start date to the end date.
        max(endDate.timeIntervalSince(startDate) / 86400, 1)
    }
    
    private var completedDays: Double {
        // Calculate days completed based on the progress ratio.
        totalDuration * progress
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(Int(completedDays)) / \(Int(totalDuration)) days")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center) // Center the text above the progress bar

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Total duration bar (background)
                    Rectangle()
                        .frame(width: geometry.size.width, height: 20)
                        .foregroundColor(Color.yellow.opacity(0.6))
                        .cornerRadius(10) // Rounded corners for the background
                    
                    // Completed duration bar (foreground)
                    Rectangle()
                        .frame(width: CGFloat(completedDays / totalDuration) * geometry.size.width, height: 20)
                        .foregroundColor(Color.green)
                        .cornerRadius(10, corners: [.topLeft, .bottomLeft]) // Rounded corners only on the left side
                    
                    // Transparent gap next to the divider
                    if completedDays > 0 && completedDays < totalDuration {
                        let dividerOffset = CGFloat(completedDays / totalDuration) * geometry.size.width
                        Rectangle()
                            .frame(width: 20, height: 20) // Transparent rectangle
                            .foregroundColor(Color.clear)
                            .offset(x: dividerOffset - 10, y: 0) // Centered on the edge with an offset
                    }
                    
                    // Small green divider
                    if completedDays > 0 && completedDays < totalDuration {
                        let dividerOffset = CGFloat(completedDays / totalDuration) * geometry.size.width - 2 // Adjust the offset
                        Rectangle()
                            .frame(width: 2, height: 24) // Slightly taller than the bar
                            .foregroundColor(Color.green)
                            .offset(x: dividerOffset, y: -2) // Centered on the edge with an offset
                    }
                }
            }
            .frame(height: 20) // Fixed height for the progress bar
            
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
        clipShape( RoundedCorner(radius: radius, corners: corners) )
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
        ProgressIndicatorView(progress: 0.175, startDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!, endDate: Date())
            .frame(height: 100)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
