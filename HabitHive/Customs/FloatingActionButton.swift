

import SwiftUI


struct CustomFloatingActionButton: View {
    let action: () -> Void
    let imageName: String
    var backgroundColor: Color = Color("Popup")  // Replace "popup" with your asset name or color
    var foregroundColor: Color = Color("Text primary")  // Replace "text primary" with your asset name or color

    var body: some View {
            Button(action: action) {
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .frame(width: 56, height: 56)
                    .foregroundColor(foregroundColor)
                    .background(backgroundColor)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        .padding()
    }
}


struct CustomFloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomFloatingActionButton(
            action: { print("FAB Tapped") },
            imageName: "plus"
        )
    }
}

