import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ProgressView()
                    .tabItem {
                        Label("Progress", systemImage: "house")
                    }
                    .tag(0)

                DailyView()
                    .tabItem {
                        Label("Daily", systemImage: "bell")
                    }
                    .tag(1)

                HabitsView()
                    .tabItem {
                        Label("Habits", systemImage: "gear")
                    }
                    .tag(2)
            }
            .navigationTitle("Habit Reminder")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Actions for the button
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}
