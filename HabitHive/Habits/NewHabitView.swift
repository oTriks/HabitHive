import SwiftUI

struct NewHabitView: View {
    @State private var step = 1
    @State private var habitName = ""
    @State private var habitDescription = ""
    @State private var frequencyOption = "Every day" // Default selection
    @State private var showDayPicker = false // Manage day picker visibility
    @State private var startDate = Date() // Assuming you need a date state for the DatePicker

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
                                    Text("0")
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

                // Navigation buttons
                HStack {
                    if step == 1 {
                        Button("Cancel") {
                            print("Creation process canceled")
                        }
                        .foregroundColor(Color("negative"))
                    } else {
                        Button("Back") {
                            if step > 1 { step -= 1 }
                        }
                        .foregroundColor(Color("negative"))

                    }

                    Spacer()

                    Button(step == 3 ? "Create" : "Next") {
                        if step < 3 {
                            step += 1
                        } else {
                            print("Habit Created")
                        }
                        
                    }
                    .foregroundColor(Color("positive"))

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
        NewHabitView()
    }
}