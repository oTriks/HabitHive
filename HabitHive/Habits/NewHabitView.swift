import SwiftUI

struct NewHabitView: View {
    @State private var step = 1
    @State private var habitName = ""
    @State private var habitDescription = ""
    @State private var frequencyOption = "Every day"
    @State private var showDayPicker = false
    @State private var startDate = Date()
    @State private var selectedNotifications: [UserNotification] = []
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: NewHabitViewModel
    @StateObject private var notificationViewModel = NotificationViewModel() // ViewModel for fetching notifications
    @Binding var isPresented: Bool
    @Binding var shouldDismissToHabits: Bool
    @State private var showingNotificationSetup = false

    init(isPresented: Binding<Bool>, shouldDismissToHabits: Binding<Bool>, userModel: UserModel) {
        self._isPresented = isPresented
        self._shouldDismissToHabits = shouldDismissToHabits
        guard let userID = userModel.userID else {
            fatalError("User ID must be set")
        }
        self._viewModel = ObservedObject(initialValue: NewHabitViewModel(userID: userID))
    }

    var endDate: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    }

    var body: some View {
        NavigationView {
            VStack {
                Group {
                    switch step {
                    case 1:
                        TextField("What habit?", text: $habitName)
                            .modifier(ElevatedTextFieldStyle())
                        TextField("Describe the habit (optional)", text: $habitDescription)
                            .modifier(ElevatedTextFieldStyle())

                    case 2:
                        FrequencySelectionView(selectedFrequency: $frequencyOption,
                                               options: ["Every day", "Specific days", "Repeat"],
                                               showDaysPicker: $showDayPicker)

                    case 3:
                        VStack(spacing: 12) {
                            // Start Date Row
                            HStack {
                                Image(systemName: "calendar")
                                    .padding(.leading)
                                Text("Start Date")
                                    .padding(.leading)
                                Spacer()
                                Text("Today")
                                    .padding(.trailing)
                            }
                            Divider().padding(.horizontal)

                            // End Date Row
                            HStack {
                                Image(systemName: "calendar")
                                    .padding(.leading)
                                Text("End Date")
                                    .padding(.leading)
                                Spacer()
                                Text(formattedDate(from: endDate))
                                    .padding(.trailing)
                            }
                            Divider().padding(.horizontal)

                            // Notifications Row
                            HStack {
                                Image(systemName: "alarm")
                                Text("Notifications")
                                    .padding(.leading)
                                Spacer()
                                Button(action: {
                                    showingNotificationSetup = true
                                }) {
                                    Text("Add new")
                                        .foregroundColor(.blue)
                                }
                                .padding(.trailing)
                            }
                            Divider().padding(.horizontal)

                            // Available Notifications List
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(notificationViewModel.notifications) { notification in
                                    HStack {
                                        Text("\(notification.time) (\(notification.type.rawValue))")
                                        Spacer()
                                        Image(systemName: selectedNotifications.contains(where: { $0.id == notification.id }) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(.blue)
                                            .onTapGesture {
                                                // Toggle selection
                                                if let index = selectedNotifications.firstIndex(where: { $0.id == notification.id }) {
                                                    selectedNotifications.remove(at: index)
                                                } else {
                                                    selectedNotifications.append(notification)
                                                }
                                            }
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }

                    default:
                        Text("Creating new habit...")
                    }
                }
                Spacer()

                HStack {
                    if step == 1 {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .foregroundColor(Color("Negative"))
                    } else {
                        Button("Back") {
                            if step > 1 { step -= 1 }
                        }
                        .foregroundColor(Color("Negative"))

                    }

                    Spacer()

                    Button(action: {
                        if step < 3 {
                            step += 1
                        } else {
                            guard let userID = userModel.userID else {
                                print("User ID not set, cannot create habit")
                                return
                            }

                            let habit = Habit(
                                name: habitName,
                                description: habitDescription,
                                frequency: frequencyOption,
                                startDate: startDate,
                                endDate: endDate,
                                userID: userID,
                                notifications: selectedNotifications // Attach selected notifications
                            )

                            viewModel.saveHabitToFirestore(habit: habit) { result in
                                switch result {
                                case .success(let updatedHabit):
                                    print("Habit Created with ID: \(updatedHabit.id ?? "unknown")")
                                    shouldDismissToHabits = true

                                case .failure(let error):
                                    print("Error creating habit: \(error)")
                                }
                            }
                        }
                    }) {
                        Text(step < 3 ? "Next" : "Create")
                    }
                    .foregroundColor(Color("Positive"))
                }
                .padding()
            }
            .sheet(isPresented: $showingNotificationSetup) {
                CustomPopupView(isPresented: $showingNotificationSetup) // Pass the binding here
            }
            .navigationTitle("Step \(step)")
            .onAppear {
                // Fetch all available notifications when the view appears
                notificationViewModel.fetchNotifications()
            }
        }
    }
}

// Date Formatting Function
func formattedDate(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
}
