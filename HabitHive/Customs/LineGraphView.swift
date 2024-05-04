import SwiftUI

struct LineGraphView: View {
    var data: [Double] // Expected values between 0 and 1

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
