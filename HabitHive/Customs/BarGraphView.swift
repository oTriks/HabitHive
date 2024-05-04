import SwiftUI

struct BarGraphView: View {
    var data: [Double] // Expected values between 0 and 1

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(data, id: \.self) { value in
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 20, height: CGFloat(value) * 200) // Height scaled by data value
            }
        }.padding()
    }
}

struct BarGraphView_Previews: PreviewProvider {
    static var previews: some View {
        BarGraphView(data: [0.5, 0.7, 0.2])
            .frame(width: 300, height: 200) // Adjust size as needed
    }
}
