import SwiftUI

struct CustomButton: View {
    var text: String
    var backgroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundColor(Color("Text primary"))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)  
                .background(backgroundColor)
                .cornerRadius(8)
                .shadow(color: .gray, radius: 10, x: 0, y: 4)
        }
    }
}


