import SwiftUI

struct CustomPopupView: View {
    var body: some View {
        ZStack {
            Color.white
                .opacity(0.9)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 20) {
                // Section 1: Notifications
                Text("Notifications")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Section 2: Notification Details
                HStack(spacing: 10) {
                    Image(systemName: "alarm")
                    VStack(){
                        Text("12:00")
                            .fontWeight(.semibold)
                        Text("Always")
                            .fontWeight(.semibold)
                    }
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                
                // Section 3: Add New Notification
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                    Text("New Notification")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.blue)
                
                // Section 4: Close
                Text("Close")
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                
                Spacer()
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CustomPopupView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPopupView()
    }
}
