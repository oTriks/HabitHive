import SwiftUI

struct HelperDialogView: View {
    @State private var showNewNotification = false

    @State private var isTouched = false
        @State private var showCheckmark = false
        @State private var cardScale: CGFloat = 1.0
        @State private var cardColor = Color.white

    
    var body: some View {
           GeometryReader { geometry in
               ZStack {
                   Color.black
                       .opacity(0.4)
                       .edgesIgnoringSafeArea(.all)
                   
                   VStack(spacing: 10) {
                       Text("Completion")
                           .font(.title)
                           .fontWeight(.semibold)
                           .foregroundColor(Color("Text trailing"))
                       
                       Divider()
                           .background(Color("Positive"))
                       
                       HStack(spacing: 10) {
                           VStack(alignment: .leading) {
                               Text("Gym")
                                   .fontWeight(.semibold)
                                   .foregroundColor(Color("Positive"))
                               
                               Text("Exercise")
                                   .font(.caption)
                                   .foregroundColor(.secondary)
                           }

                           Spacer()

                           Circle()
                               .fill(Color("Positive"))
                               .frame(width: 30, height: 30)
                               .overlay(
                                   Image(systemName: showCheckmark ? "checkmark" : "")
                                       .foregroundColor(.white)
                               )
                       }
                       .padding()
                       .background(cardColor)
                       .cornerRadius(10)
                       .shadow(radius: 5)
                       .scaleEffect(cardScale)
                       .onTapGesture {
                           animateTouchAndCheckmark()
                       }
                       
                       Divider()
                           .background(Color("Positive"))
                       
                       Text("Close")
                           .fontWeight(.semibold)
                           .foregroundColor(Color("Negative"))

                       Spacer()
                   }
                   .padding()
                   .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3)
                   .background(Color.white)
                   .cornerRadius(15)
                   .shadow(radius: 10)
                   .overlay(
                       RoundedRectangle(cornerRadius: 15)
                           .stroke(Color.gray, lineWidth: 1)
                   )
                   .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
               }
           }
       }

       private func animateTouchAndCheckmark() {
           withAnimation(.easeIn(duration: 0.1)) {
               cardScale = 0.95
               cardColor = Color.gray.opacity(0.1)
           }

           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               withAnimation(.easeOut(duration: 0.1)) {
                   cardScale = 1.0
                   cardColor = Color.white
               }

               DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                   withAnimation {
                       showCheckmark = true
                   }
               }
           }
       }
   }

   struct HelperDialogView_Previews: PreviewProvider {
       static var previews: HelperDialogView {
           HelperDialogView()
       }
   }
