import SwiftUI
struct FrequencySelectionView: View {
    @Binding var selectedFrequency: String
    let options: [String]
    @Binding var showDaysPicker: Bool
    @State private var repeatDays: Int = 2
    @State private var selectedDays: Set<String> = [] 

    var body: some View {
        VStack {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    self.selectedFrequency = option
                    self.showDaysPicker = (option == "Specific days")
                }) {
                    HStack {
                        Image(systemName: selectedFrequency == option ? "largecircle.fill.circle" : "circle")
                            .foregroundColor(selectedFrequency == option ? Color("Positive") : .gray)
                        Text(option)
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(self.selectedFrequency == option ? Color("Positive").opacity(0.1) : Color.clear)
                .cornerRadius(5)

                if option == "Specific days" && showDaysPicker {
                    DayPickerView(selectedDays: $selectedDays)
                }
            }
        }
        .padding()
    }
}
