import SwiftUI

// Struct representing a notification
struct UserNotification: Identifiable, Codable {
    let id: String // Unique identifier as a String
    let time: String
    let type: NotificationType

    // Initialize with a string `id`
    init(id: String = UUID().uuidString, time: String, type: NotificationType) {
        self.id = id
        self.time = time
        self.type = type
    }
}

enum NotificationType: String, Codable {
    case silent = "Silent"
    case notification = "Notification"
    case alarm = "Alarm"
}


struct CustomPopupView: View {
    @Binding var isPresented: Bool
    @State private var showNewNotification = false // State to toggle content
    @State private var selectedTime = Date() // State to store the selected time
    @State private var selectedNotificationType: NotificationType = .silent // Default type
    @StateObject private var viewModel = NotificationViewModel() // Create the view model


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
                                // DatePicker for the time
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(Color("Positive"))
                                    DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden() // Hide label to show only time
                                }

                                Divider()
                                    .background(Color("Positive"))

                                // Notification type selection (Silent, Notification, Alarm)
                                HStack(spacing: 20) {
                                    ForEach(NotificationType.allCases, id: \.self) { type in
                                        VStack {
                                            Text(type.rawValue)
                                                .fontWeight(.semibold)
                                            Image(systemName: icon(for: type))
                                                .foregroundColor(Color("Positive"))
                                        }
                                        .onTapGesture {
                                            selectedNotificationType = type
                                        }
                                        .foregroundColor(type == selectedNotificationType ? Color("Positive") : .secondary)
                                    }
                                }

                                Divider()
                                    .background(Color("Positive"))
                            }

                            // Cancel and Confirm Buttons
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
                                    .onTapGesture {
                                        // Confirm the notification settings
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "h:mm a"
                                        let formattedTime = formatter.string(from: selectedTime)

                                        let newNotification = UserNotification(time: formattedTime, type: selectedNotificationType)
                                        viewModel.addNotification(newNotification) // Add notification to Firestore
                                        showNewNotification = false
                                    }
                            }
                        } else {
                            // Display existing notifications
                            Text("Notifications")
                                .font(.title)
                                .fontWeight(.semibold)

                            ForEach(viewModel.notifications) { notification in
                                HStack(spacing: 70) {
                                    Image(systemName: icon(for: notification.type))
                                        .foregroundColor(Color("Positive"))
                                    VStack {
                                        Text(notification.time)
                                            .fontWeight(.semibold)
                                    }
                                    Image(systemName: "trash")
                                        .foregroundColor(Color("Negative"))
                                        .onTapGesture {
                                            viewModel.removeNotification(withId: notification.id) // Remove from Firestore
                                        }
                                }
                                Divider()
                                    .background(Color("Positive"))
                            }

                            // New Notification Button
                            HStack(spacing: 10) {
                                Image(systemName: "plus")
                                Text("New Notification")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(Color("Positive"))
                            .onTapGesture {
                                showNewNotification = true
                            }

                            Divider()
                                .background(Color("Positive"))

                            Text("Close")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("Negative"))
                                .onTapGesture {
                                    isPresented = false // Close the popup
                                }

                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .fixedSize(horizontal: false, vertical: true) // Ensure vertical expansion
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }

        // Helper function to map the notification type to an icon
        private func icon(for type: NotificationType) -> String {
            switch type {
            case .silent:
                return "bell.slash.fill"
            case .notification:
                return "bell.fill"
            case .alarm:
                return "alarm.fill"
            }
        }
    }


  // Allow NotificationType to be used with `ForEach`
  extension NotificationType: CaseIterable {}


