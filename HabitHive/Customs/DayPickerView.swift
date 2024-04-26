import SwiftUI

struct DayPickerView: View {
    var daysOfWeek = [
        ("S", UUID()), ("M", UUID()), ("T", UUID()),
        ("W", UUID()), ("T", UUID()), ("F", UUID()), ("S", UUID())
    ]
    @State private var selectedDays: Set<UUID> = []

    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.1) { day, id in
                Button(day) {
                    if selectedDays.contains(id) {
                        selectedDays.remove(id)
                    } else {
                        selectedDays.insert(id)
                    }
                }
                .foregroundColor(selectedDays.contains(id) ? Color("positive") : .gray)
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .shadow(color: .gray, radius: 2, x: 0, y: 1)
            }
        }
    }
}
