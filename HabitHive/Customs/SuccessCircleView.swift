import SwiftUI

struct CircleSegment: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var innerRadiusFactor: CGFloat = 0.7

    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let outerRadius = min(rect.width, rect.height) / 2
            let innerRadius = outerRadius * innerRadiusFactor

            let adjustedStartAngle = startAngle - .degrees(90)
            let adjustedEndAngle = endAngle - .degrees(90)

            path.addArc(center: center, radius: outerRadius, startAngle: adjustedStartAngle, endAngle: adjustedEndAngle, clockwise: false)
            
            path.addArc(center: center, radius: innerRadius, startAngle: adjustedEndAngle, endAngle: adjustedStartAngle, clockwise: true)
            
            path.closeSubpath()
        }
    }
}

struct SuccessCircleView: View {
    var doneCount: Int
    var failedCount: Int
    var pendingCount: Int

    private var totalTasks: Double {
        Double(doneCount + failedCount + pendingCount)
    }

    private var doneAngle: Double {
        (Double(doneCount) / totalTasks) * 360
    }
    
    private var failedAngle: Double {
        (Double(failedCount) / totalTasks) * 360
    }

    private var pendingAngle: Double {
        (Double(pendingCount) / totalTasks) * 360
    }

    var body: some View {
        ZStack {
            CircleSegment(startAngle: .degrees(0), endAngle: .degrees(doneAngle), innerRadiusFactor: 0.7)
                .fill(Color.green)
            CircleSegment(startAngle: .degrees(doneAngle), endAngle: .degrees(doneAngle + failedAngle), innerRadiusFactor: 0.7)
                .fill(Color.red)
            CircleSegment(startAngle: .degrees(doneAngle + failedAngle), endAngle: .degrees(doneAngle + failedAngle + pendingAngle), innerRadiusFactor: 0.7)
                .fill(Color.yellow)
        }
        .frame(width: 200, height: 200)
        .overlay(Circle().stroke(Color.black, lineWidth: 2))
    }
}

struct SuccessCircleView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessCircleView(doneCount: 2, failedCount: 1, pendingCount: 1)
    }
}
