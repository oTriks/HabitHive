import SwiftUI

struct UserNotification: Identifiable, Codable {
    let id: String
    let time: String
    let type: NotificationType

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
    @State private var showNewNotification = false
    @State private var selectedTime = Date()
    @State private var selectedNotificationType: NotificationType = .silent
    @StateObject private var viewModel = NotificationViewModel()


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
                                    DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                }

                                Divider()
                                    .background(Color("Positive"))

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
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "h:mm a"
                                        let formattedTime = formatter.string(from: selectedTime)

                                        let newNotification = UserNotification(time: formattedTime, type: selectedNotificationType)
                                        viewModel.addNotification(newNotification)
                                        showNewNotification = false
                                    }
                            }
                        } else {
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
                                            viewModel.removeNotification(withId: notification.id)
                                        }
                                }
                                Divider()
                                    .background(Color("Positive"))
                            }

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
                                    isPresented = false
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
                    .fixedSize(horizontal: false, vertical: true)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }

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


  extension NotificationType: CaseIterable {}


