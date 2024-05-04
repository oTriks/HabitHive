import SwiftUI

struct DayPickerView: View {
    let daysOfWeek = ["S", "M", "T", "W", "TH", "F", "SA"]
    @Binding var selectedDays: Set<String>

    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Button(day) {
                    if selectedDays.contains(day) {
                        selectedDays.remove(day)
                        print("Removed \(day), selectedDays now: \(selectedDays)")
                    } else {
                        selectedDays.insert(day)
                        print("Added \(day), selectedDays now: \(selectedDays)")
                    }
                }
                .foregroundColor(selectedDays.contains(day) ? Color("Positive") : .gray)
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
            }
        }
    }
}
