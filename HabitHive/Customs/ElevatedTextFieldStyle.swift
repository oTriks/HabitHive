import SwiftUI

struct ElevatedTextFieldStyle: ViewModifier {
    var bgColor: Color = .white
    var shadowColor: Color = .gray
    var shadowRadius: CGFloat = 5
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = 2
    var cornerRadius: CGFloat = 5
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(bgColor)
            .cornerRadius(cornerRadius)
            .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
            .padding()
    }
}

