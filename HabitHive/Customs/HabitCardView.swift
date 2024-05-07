import SwiftUI

struct HabitCardView: View {
    var habit: Habit
    @ObservedObject var viewModel: HabitsViewModel
    @State private var isShowingCalendar = false
    @State private var isShowingEdit = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(habit.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(habit.frequency)
                        .font(.caption)
                        .foregroundColor(Color("Positive"))
                }

                if !habit.description.isEmpty {
                    Text(habit.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                VStack {
                    if let progressMap = habit.progress, !progressMap.isEmpty, let habitId = habit.id {
                        ScrollableWeekdaysView(
                            progressMap: progressMap,
                            currentDate: Date(),
                            habitId: habitId,
                            viewModel: viewModel
                        )
                        .frame(height: 60)
                        .padding()
                    }

                    HStack {
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(Color("Positive"))
                            .onTapGesture {
                                isShowingCalendar = true
                            }

                        Image(systemName: "pencil")
                            .foregroundColor(Color("Negative"))
                            .onTapGesture {
                                isShowingEdit = true
                            }
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 2)
            .padding(.horizontal)

            if isShowingCalendar {
                ZStack {
                    Color.black.opacity(0.0)
                        .edgesIgnoringSafeArea(.all)

                    CalendarView(
                        habitID: habit.id ?? "",
                        viewModel: viewModel,
                        isPresented: $isShowingCalendar
                    )
                    .frame(width: 360, height: 480)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 20)
                }
                .transition(.opacity)
                .zIndex(1)
            }

        }
    }
}
