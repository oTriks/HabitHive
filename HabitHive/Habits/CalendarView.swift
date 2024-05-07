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

    @State private var currentDate: Date = Date()

    var body: some View {
        VStack {
            Picker(selection: $selectedTab, label: Text("")) {
                Text("Calendar").tag(0)
                Text("Edit").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 15)
            .padding(.vertical, 5)

            if selectedTab == 0 {
                HStack {
                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("Negative"))
                    }

                    Spacer()

                    Text(currentDate.monthNameAndYear)
                        .font(.subheadline)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: {
                        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color("Positive"))
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)

                MonthlyCalendarGrid(
                    currentDate: currentDate,
                    habitProgress: habit?.progress ?? [:],
                    viewModel: viewModel,
                    habitID: habitID
                )
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
            } else {
                VStack(alignment: .leading, spacing: 19) {
                    HStack {
                        Text("Habit Name")
                            .font(.subheadline)
                        Spacer()
                        TextField("Enter habit name", text: $habitName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 120)
                            .padding(.leading, 8)
                    }

                    HStack {
                        Text("Description")
                            .font(.subheadline)
                        Spacer()
                        TextField("Enter description", text: $habitDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 120)
                            .padding(.leading, 8)
                    }

                    HStack {
                        Text("Frequency")
                            .font(.subheadline)
                        Spacer()
                        TextField("Enter frequency", text: $habitFrequency)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 120)
                            .padding(.leading, 8)
                    }

                    HStack {
                        Text("Start date")
                            .font(.subheadline)
                        Spacer()
                        Button("\(habitStartDate.formattedString())") {
                            showStartDatePicker.toggle()
                        }
                        .foregroundColor(Color("Positive"))
                        if showStartDatePicker {
                            DatePicker(selection: $habitStartDate, displayedComponents: [.date]) {
                                EmptyView()
                            }
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding(.leading, 8)
                        }
                    }

                    HStack {
                        Text("End date")
                            .font(.subheadline)
                        Spacer()
                        Button("\(habitEndDate.formattedString())") {
                            showEndDatePicker.toggle()
                        }
                        .foregroundColor(Color("Positive"))
                        if showEndDatePicker {
                            DatePicker(selection: $habitEndDate, displayedComponents: [.date]) {
                                EmptyView()
                            }
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding(.leading, 8)
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
                .padding(10)
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
        .frame(width: 360, height: 480)
        .background(Color("Calendar"))
        .cornerRadius(30)
        .shadow(radius: 15)
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
        let firstDayOfMonth = currentDate.startOfMonth()
        let currentYear = Calendar.current.component(.year, from: currentDate)
        let currentMonth = Calendar.current.component(.month, from: currentDate)

        let daysInMonthRange = Calendar.current.range(of: .day, in: .month, for: firstDayOfMonth)!
        let daysInMonth = daysInMonthRange.count

        let calendar = Calendar.current
        let startWeekday = calendar.component(.weekday, from: firstDayOfMonth)

        var weekdaySymbols = calendar.shortWeekdaySymbols
        let reorderedWeekdaySymbols = weekdaySymbols[0...] + weekdaySymbols[0..<0]

        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(0..<7, id: \.self) { dayIndex in
                let dayString = String(reorderedWeekdaySymbols[dayIndex].prefix(1))
                Text(dayString)
                    .fontWeight(.bold)
                    .padding()


            }

            ForEach(0..<(startWeekday - 1), id: \.self) { index in
                Text("")
                    .id("empty-\(index)")
            }

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
                        viewModel.updateProgress(for: habitID, date: dateKey)
                    }
                    .id("day-\(day)")
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(self.borderColorForStatus(status), lineWidth: 1)
                    )
            }
        }
    }

       private func backgroundForStatus(_ status: String) -> Color {
           switch status {
           case "Done":
               return Color("Positive")
           case "Failed":
               return Color("Negative")
           case "Pending":
               return .clear
           default:
               return .gray
           }
       }
    
       private func textColorForStatus(_ status: String) -> Color {
           switch status {
           case "Done", "Failed":
               return .white
           case "Pending":
               return .black
           default:
               return .black
           }
       }
        private func borderColorForStatus(_ status: String) -> Color {
            switch status {
            case "Pending":
                return .black
            default:
                return .clear
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
