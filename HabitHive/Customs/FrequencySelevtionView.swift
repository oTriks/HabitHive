import SwiftUI

struct FrequencySelectionView: View {
    @Binding var selectedFrequency: String
    let options: [String]
    @Binding var showDaysPicker: Bool
    @State private var repeatDays: Int = 2
    @State private var selectedDays: [String] = []

    var body: some View {
        VStack {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    self.selectedFrequency = option
                    self.showDaysPicker = (option == "Specific days")
                }) {
                    HStack {
                        Image(systemName: self.selectedFrequency == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(self.selectedFrequency == option ? Color("positive") : .gray)
                        Text(option)
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(self.selectedFrequency == option ? Color("positive").opacity(0.1) : Color.clear)
                .cornerRadius(5)

                // Show the DayPickerView for "Specific days"
                if option == "Specific days" && showDaysPicker {
                    DayPickerView()
                }

                // Layout for "Repeat" option
                if option == "Repeat" && selectedFrequency == "Repeat" {
                    HStack {
                        Text("Every")
                            .foregroundColor(.black)
                        
                        TextField("", value: $repeatDays, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .frame(width: 50)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                        
                        Text("days")
                            .foregroundColor(.black)
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}
