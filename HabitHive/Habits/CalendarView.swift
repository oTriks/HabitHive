import SwiftUI

struct CalendarView: View {
    var habitID: String
    @ObservedObject var viewModel: HabitsViewModel
    @Binding var isPresented: Bool
    @State private var selectedTab = 0
    
    @State private var formattedStartDate: String = ""
    @State private var formattedEndDate: String = ""
    @State private var habitName: String = ""
    @State private var habitDescription: String = ""
    @State private var habitFrequency: String = ""
    @State private var habitStartDate: Date = Date()
    @State private var habitEndDate: Date = Date()
    @State private var showStartDatePicker = false
    @State private var showEndDatePicker = false
    @State private var isShowingEdit = false // Add state variable for edit tab

    // Month navigation state variable
    @State private var currentDate: Date = Date()

    var body: some View {
        VStack {
            Picker(selection: $selectedTab, label: Text("")) {
                Text("Calendar").tag(0)
                Text("Edit").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedTab == 0 {
                // Month navigation header
                HStack {
                    Button(action: {
                        // Move backward by one month
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Negative"))
                    }

                    Spacer()

                    Text(currentDate.monthNameAndYear)
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: {
                        // Move forward by one month
                        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color("Positive"))
                    }
                }
                .padding()

                // Display the calendar grid for the current month
                MonthlyCalendarGrid(
                    currentDate: currentDate, 
                                   habitProgress: habit?.progress ?? [:],
                                   viewModel: viewModel,
                                   habitID: habitID
                               )
                               .padding()
                           } else {
                               VStack(alignment: .leading, spacing: 15) {
                                   HStack {
                                       Text("Habit Name")
                                       Spacer()
                                       TextField("Enter habit name", text: $habitName)
                                           .textFieldStyle(RoundedBorderTextFieldStyle())
                                           .frame(width: 150) // Set a smaller width
                                           .padding(.leading, 10)
                                   }
                                   
                                   HStack {
                                       Text("Description")
                                       Spacer()
                                       TextField("Enter description", text: $habitDescription)
                                           .textFieldStyle(RoundedBorderTextFieldStyle())
                                           .frame(width: 150) // Set a smaller width
                                           .padding(.leading, 10)
                                   }
                                   
                                   HStack {
                                       Text("Frequency")
                                       Spacer()
                                       TextField("Enter frequency", text: $habitFrequency)
                                           .textFieldStyle(RoundedBorderTextFieldStyle())
                                           .frame(width: 150) // Set a smaller width
                                           .padding(.leading, 10)
                                   }
                                   HStack {
                                       Text("Start date")
                                       Spacer()
                                       Button("\(habitStartDate.formattedString())") {
                                           showStartDatePicker.toggle()
                                       }
                                       .foregroundColor(Color("Positive"))
                                       if showStartDatePicker {
                                           DatePicker(selection: $habitStartDate, displayedComponents: [.date]) {
                                               EmptyView()
                                           }                                .datePickerStyle(CompactDatePickerStyle())
                                               .background(Color("Positive").opacity(0))
                                               .padding(.leading, 10)
                                       }
                                   }
                                   
                                   HStack {
                                       Text("End date")
                                       Spacer()
                                       Button("\(habitEndDate.formattedString())") {
                                           showEndDatePicker.toggle()
                                       }
                                       .foregroundColor(Color("Positive"))
                                       if showEndDatePicker {
                                           DatePicker(selection: $habitEndDate, displayedComponents: [.date]){
                                               EmptyView()
                                           }
                                           .datePickerStyle(CompactDatePickerStyle())
                                           .background(Color("Positive").opacity(0))
                                           .padding(.leading, 10)
                                       }
                                   }
                                   Divider()
                                   HStack {
                                       Spacer()
                                       
                                       Button("Save Changes") {
                                           viewModel.updateHabit(
                                               habitID: habitID,
                                               name: habitName,
                                               description: habitDescription,
                                               frequency: habitFrequency,
                                               startDate: habitStartDate,
                                               endDate: habitEndDate
                                           )
                                       }
                                       .foregroundColor(Color("Positive"))
                                       Spacer()
                                   }
                                   Divider()
                               }
                               .padding()
                           }
                           HStack {
                               Spacer()
                               Button("Close") {
                    isPresented = false
                }
                .padding(.trailing)
                .foregroundColor(Color("Negative"))
            }
        }
        .onAppear {
            if let habit = habit {
                habitName = habit.name
                habitDescription = habit.description
                habitFrequency = habit.frequency
                habitStartDate = habit.startDate
                habitEndDate = habit.endDate
                formattedStartDate = habit.startDate.formattedString()
                formattedEndDate = habit.endDate.formattedString()
            }
        }
        .frame(width: 400, height: 520)
        .background(Color("Calendar"))
        .cornerRadius(40)
        .shadow(radius: 20)
    }

    private var habit: Habit? {
        viewModel.habits.first { $0.id == habitID }
    }
}



extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var monthNameAndYear: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: self)
        }
    func startOfMonth() -> Date {
            let components = Calendar.current.dateComponents([.year, .month], from: self)
            return Calendar.current.date(from: components)!
        }
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
}



struct MonthlyCalendarGrid: View {
    var currentDate: Date
    var habitProgress: [String: String]
    @State private var selectedDate: String?
    var viewModel: HabitsViewModel
    var habitID: String

    var body: some View {
        // Determine the first day of the current month
        let firstDayOfMonth = currentDate.startOfMonth()
        let currentYear = Calendar.current.component(.year, from: currentDate)
        let currentMonth = Calendar.current.component(.month, from: currentDate)

        // Calculate the total number of days in the current month
        let daysInMonthRange = Calendar.current.range(of: .day, in: .month, for: firstDayOfMonth)!
        let daysInMonth = daysInMonthRange.count

        // Get the weekday for the first day of the month (1 = Sunday, etc.)
        let calendar = Calendar.current
        let startWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        // Adjust the weekday symbols so the first day starts on Sunday
        var weekdaySymbols = calendar.shortWeekdaySymbols
        let reorderedWeekdaySymbols = weekdaySymbols[0...] + weekdaySymbols[0..<0]

        // Create a grid with 7 columns representing the days of the week
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            // Add headers for the days of the week
            ForEach(0..<7, id: \.self) { dayIndex in
                let dayString = String(reorderedWeekdaySymbols[dayIndex].prefix(1))
                Text(dayString)
                    .fontWeight(.bold)
                    .padding()
            }

            // Fill in blank days to align the first day of the month correctly
            ForEach(0..<(startWeekday - 1), id: \.self) { index in
                Text("") // Ensure this is a valid view
                    .id("empty-\(index)")
            }

            // Add the days of the month starting from day 1 up to the total number of days
            ForEach(1...daysInMonth, id: \.self) { day in
                let dateKey = "\(currentYear)-\(String(format: "%02d", currentMonth))-\(String(format: "%02d", day))"
                let status = habitProgress[dateKey] ?? "Pending"

                Text("\(day)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(8)
                    .background(self.backgroundForStatus(status))
                    .cornerRadius(8)
                    .foregroundColor(self.textColorForStatus(status))
                    .onTapGesture {
                        selectedDate = dateKey
                        // Update the progress status
                        viewModel.updateProgress(for: habitID, date: dateKey)
                    }
                    .id("day-\(day)")
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(self.borderColorForStatus(status), lineWidth: 1) // Adjust border thickness
                    )
            }
        }
    }

    // Background color based on the status
       private func backgroundForStatus(_ status: String) -> Color {
           switch status {
           case "Done":
               return Color("Positive")
           case "Failed":
               return Color("Negative")
           case "Pending":
               return .clear // No background color
           default:
               return .gray
           }
       }
    
    // Text color based on the status
       private func textColorForStatus(_ status: String) -> Color {
           switch status {
           case "Done", "Failed":
               return .white // White text for Done and Failed statuses
           case "Pending":
               return .black // Black text for Pending status
           default:
               return .black
           }
       }
    // Border color based on the status
        private func borderColorForStatus(_ status: String) -> Color {
            switch status {
            case "Pending":
                return .black // Black border for Pending status
            default:
                return .clear // No border for other statuses
            }
        }
    
    
   }


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HabitsViewModel()
        let habitID = "5ny2HxATYpJUGIQ2itGj"
        
        let mayDateComponents = DateComponents(year: 2024, month: 5, day: 1)
        let mayDate = Calendar.current.date(from: mayDateComponents)!
        
        return CalendarView(habitID: habitID, viewModel: viewModel, isPresented: .constant(false))
            .environmentObject(viewModel)
            .previewLayout(.sizeThatFits)
            .padding()
            .environment(\.locale, Locale(identifier: "en_US"))
            .previewDisplayName("May 2024")
    }
}
