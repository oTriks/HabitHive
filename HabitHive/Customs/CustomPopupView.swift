import SwiftUI

struct CustomPopupView: View {
    @State private var showNewNotification = false // State to toggle content

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10) {
                    if showNewNotification {
                        Text("New Notification")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 10) {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(Color("Positive"))
                                Text("12:00 PM")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("Positive"))
                            }
                            Divider() // Adds a line separator here
                                .background(Color("Positive"))


                            // The section with three icons and text labels
                            HStack(spacing: 20) {
                                VStack {
                                    Text("Silent")
                                        .fontWeight(.semibold)
                                    Image(systemName: "bell.slash.fill")
                                        .foregroundColor(Color("Positive"))
                                }
                                VStack {
                                    Text("Notification")
                                        .fontWeight(.semibold)
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(Color("Positive"))
                                }
                                VStack {
                                    Text("Alarm")
                                        .fontWeight(.semibold)
                                    Image(systemName: "alarm.fill")
                                        .foregroundColor(Color("Positive"))
                                }
                            }
                            Divider() // Another divider
                                .background(Color("Positive"))

                        }
                        HStack(spacing: 70) {
                            Text("Cancel")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Negative"))
                                .onTapGesture {
                                    showNewNotification = false
                                }
                            Text("Confirm")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Positive"))
                        }
                    } else {
                        Text("Notifications")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 70) {
                            Image(systemName: "alarm")
                                .foregroundColor(Color("Positive"))
                            VStack {
                                Text("12:00")
                                    .fontWeight(.semibold)
                            }
                            Image(systemName: "trash")
                                .foregroundColor(Color("Negative"))
                        }
                        Divider() 
                            .background(Color("Positive"))
                        // Adds a separator between the alarm and "New Notification"
                        
                        HStack(spacing: 10) {
                            Image(systemName: "plus")
                            Text("New Notification")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(Color("Positive"))
                        .onTapGesture {
                            showNewNotification = true // Show new notification content
                        }
                        
                        Divider() // Another divider before "Close"
                            .background(Color("Positive"))

                        
                        Text("Close")
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Negative"))
                    }
                    
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
}

struct CustomPopupView_Previews: PreviewProvider {
    static var previews: CustomPopupView {
        CustomPopupView()
    }
}
