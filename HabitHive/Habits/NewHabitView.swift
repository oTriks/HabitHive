import SwiftUI

struct NewHabitView: View {
    @State private var step = 1
    @State private var habitName = ""
    @State private var habitDescription = ""
    @State private var frequencyOption = "Every day"
    @State private var showDayPicker = false
    @State private var startDate = Date()
    @ObservedObject var viewModel = NewHabitViewModel()
    @Binding var isPresented: Bool
    @Binding var shouldDismissToHabits: Bool

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
                        VStack {
                            HStack {
                                Image(systemName: "calendar")
                                    .padding(.leading)
                                Text("Start Date")
                                    .padding(.leading)
                                Spacer()
                                Text("Today")
                                    .padding(.trailing)
                            }
                            Divider()
                                .padding(.horizontal)
                            
                            VStack {
                                Divider()
                                    .padding(.horizontal)
                                HStack {
                                    Image(systemName: "calendar")
                                        .padding(.leading)
                                    Text("End Date")
                                        .padding(.leading)

                                    Spacer()
                                    Toggle("", isOn: .constant(false))
                                        .padding(.trailing)
                                }
                                Divider()
                                    .padding(.horizontal)
                                HStack {
                                    Image(systemName: "alarm")
                                    Text("Notifications")
                                        .padding(.leading)
                                    Spacer()
                                    Button(action: {
                                        // Open NewHabitView when Notifications is pressed
                                        // You can set some state variable to trigger the navigation
                                    }) {
                                        Text("0")
                                    }
                                    .foregroundColor(.blue)
                                    .padding(.trailing)
                                }
                                .padding(.horizontal)
                            }
                            Spacer()
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

                    Button(step == 3 ? "Create" : "Next") {
                        if step < 3 {
                            step += 1
                        } else {
                            let habit = Habit(name: habitName, description: habitDescription, frequency: frequencyOption, startDate: startDate)
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
                    }
                    .foregroundColor(Color("Positive"))

                }
                .padding()
            }
            .navigationTitle("Step \(step)")
        }
    }
}

func formattedDate(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
}

struct NewHabitView_Previews: PreviewProvider {
    static var previews: some View {
        NewHabitView(isPresented: .constant(false), shouldDismissToHabits: .constant(false))
    }
}


