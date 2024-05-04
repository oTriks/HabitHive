import SwiftUI

struct ProgressHabitView: View {
    var habit: Habit

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Habit Name: \(habit.name)")
                    .font(.title)
                    .padding()

                Divider()

                Text("Description: \(habit.description)")
                    .padding()

                Divider()

                Text("Frequency: \(habit.frequency)")
                    .padding()

                if let daysOfWeek = habit.daysOfWeek, !daysOfWeek.isEmpty {
                    SectionHeaderView(title: "Active Days")
                    Text("Active on: \(daysOfWeek.joined(separator: ", "))")
                        .padding()
                    Divider()
                }

                if let progressMap = habit.progress {
                    SectionHeaderView(title: "Progress")
                    ForEach(progressMap.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        HStack {
                            Text("\(key): ").bold()
                            Text(value)
                        }
                        .padding()
                    }
                    Divider()
                }

                if let dailyMap = habit.dailyMap {
                    SectionHeaderView(title: "Daily Status")
                    ForEach(dailyMap.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        HStack {
                            Text("\(key): ")
                            Image(systemName: value ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(value ? .green : .red)
                        }
                        .padding()
                    }
                    Divider()
                }
            }
            .navigationBarTitle(Text("Habit Details"), displayMode: .inline)
        }
    }
}

// Simple Section Header View
struct SectionHeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top)
    }
}
