
import SwiftUI


struct Checkbox: View {
    @Binding var isChecked: Bool
    var label: String
    
    var body: some View {
        Button(action: {
            self.isChecked.toggle()
        }) {
            HStack {
                Text(label)
                    .foregroundColor(Color("text trailing"))  
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .foregroundColor(Color("outline"))
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
        }
        .padding() 
    }
}
