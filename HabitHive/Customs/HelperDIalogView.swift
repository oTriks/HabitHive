import SwiftUI

struct HelperDialogView: View {
    @State private var showNewNotification = false // State to toggle content

    @State private var isTouched = false // Tracks if the card is "touched"
        @State private var showCheckmark = false // Whether to show the checkmark
        @State private var cardScale: CGFloat = 1.0 // For tap animation effect
        @State private var cardColor = Color.white // For changing the card color temporarily

    
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
                       
                       // Card that shows the checkmark after "touch"
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

                           // Circle with a checkmark
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
                       .scaleEffect(cardScale) // Apply the scaling effect
                       .onTapGesture {
                           animateTouchAndCheckmark() // Trigger the tap animation and checkmark
                       }
                       
                       Divider()
                           .background(Color("Positive"))
                       
                       Text("Close")
                           .fontWeight(.semibold)
                           .foregroundColor(Color("Negative"))

                       Spacer()
                   }
                   .padding()
                   .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3) // Adjust width and height
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

       // Function to animate both touch and adding the checkmark
       private func animateTouchAndCheckmark() {
           // Start the scale-down effect and change card color
           withAnimation(.easeIn(duration: 0.1)) {
               cardScale = 0.95
               cardColor = Color.gray.opacity(0.1) // A light gray color to simulate touch
           }

           // Revert scale and color, then add checkmark after a slight delay
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               withAnimation(.easeOut(duration: 0.1)) {
                   cardScale = 1.0
                   cardColor = Color.white // Revert to the original card color
               }

               // Add the checkmark with a delay
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
