import SwiftUI

struct NewHabitView: View {
    @State private var step = 1
    @State private var habitName = ""
    @State private var habitDescription = ""
    @State private var frequencyOption = "Every day"
    @State private var showDayPicker = false
    @State private var startDate = Date()
    @State private var selectedNotifications: [UserNotification] = []
    @State private var isStartDatePickerVisible = false
    @State private var isEndDatePickerVisible = false
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel: NewHabitViewModel
    @StateObject private var notificationViewModel = NotificationViewModel()
    @Binding var isPresented: Bool
    @Binding var shouldDismissToHabits: Bool
    @State private var showingNotificationSetup = false
    @Environment(\.presentationMode) var presentationMode

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
                                               options: ["Every day", "Specific days"],
                                               showDaysPicker: $showDayPicker)

                    case 3:
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "calendar")
                                    .padding(.leading)
                                Text("Start Date")
                                    .padding(.leading)
                                Spacer()
                                
                                
                                
                                Text("Today")
                                    .padding(.trailing)
                                    .foregroundColor(Color("Positive"))

                            }
                            Divider().padding(.horizontal)

                            HStack {
                                Image(systemName: "calendar")
                                    .padding(.leading)
                                Text("End Date")
                                    .padding(.leading)
                                Spacer()
                                Text(formattedDate(from: endDate))
                                    .padding(.trailing)
                                    .foregroundColor(Color("Positive"))
                            }
                            Divider().padding(.horizontal)

                            HStack {
                                Image(systemName: "alarm")
                                    .padding(.leading)
                                Text("Notifications")
                                    .padding(.leading)
                                Spacer()
                                Button(action: {
                                    showingNotificationSetup = true
                                }) {
                                    Text("Add new")
                                        .foregroundColor(Color("Positive"))
                                }
                                .padding(.trailing)
                            }
                            Divider().padding(.horizontal)
                            
                            let sortedNotifications = notificationViewModel.notifications.sorted { $0.time < $1.time }
                            VStack(alignment: .leading, spacing: 8) {
                                       ForEach(sortedNotifications) { notification in
                                           HStack {
                                               Text("\(notification.time) (\(notification.type.rawValue))")
                                                   .padding(.leading)
                                                   .padding(.leading)
                                               Spacer()
                                               Image(systemName: selectedNotifications.contains(where: { $0.id == notification.id }) ? "checkmark.circle.fill" : "circle")
                                                   .foregroundColor(Color("Positive"))
                                                   .onTapGesture {
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
                        .padding()
                    } else {
                        Button("Back") {
                            if step > 1 { step -= 1 }
                        }
                        .foregroundColor(Color("Negative"))
                        .padding()


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
                                notifications: selectedNotifications
                            )

                            viewModel.saveHabitToFirestore(habit: habit) { result in
                                switch result {
                                case .success(let updatedHabit):
                                    print("Habit Created with ID: \(updatedHabit.id ?? "unknown")")
                                    shouldDismissToHabits = true
                                    presentationMode.wrappedValue.dismiss()

                                case .failure(let error):
                                    print("Error creating habit: \(error)")
                                }
                            }
                        }
                    }) {
                        Text(step < 3 ? "Next" : "Create")
                    }
                    .foregroundColor(Color("Positive"))
                    .padding()

                }
                .padding()
            }
            .sheet(isPresented: $showingNotificationSetup) {
                CustomPopupView(isPresented: $showingNotificationSetup)
            }
            .navigationTitle(headerTitle(for: step))
            .onAppear {
                notificationViewModel.fetchNotifications()
                
            }
        }
    }

    
    
    private func headerTitle(for step: Int) -> String {
        switch step {
        case 1:
            return "Name & description"
        case 2:
            return "Set Frequency"
        case 3:
            return "When & notifications"
        default:
            return "New Habit"
        }
    }
}

func formattedDate(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
}
