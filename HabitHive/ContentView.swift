import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    var habits: [Habit] = []

    var navigationTitle: String {
        switch selection {
        case 0:
            return "Progress"
        case 1:
            return "Daily"
        case 2:
            return "Habits"
        default:
            return "Habit Reminder"
        }
    }
    
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
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Actions for the button
                    }) {
                        Image("avatar_dark")
                            .resizable() // Make the image resizable
                                    .frame(width: 48, height: 48) // Set the desired width and height
                    }
                }
            }
        }
    }
}
