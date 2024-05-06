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
                        Label("Progress", systemImage: "chart.bar.doc.horizontal.fill")
                    }
                    .tag(0)
                
                DailyView()
                    .tabItem {
                        Label("Daily", systemImage: "calendar")
                    }
                    .tag(1)
                
                HabitsView()
                    .tabItem {
                        Label("Habits", systemImage: "list.bullet")
                    }
                    .tag(2)
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                    }) {
                        Image("avatar_dark")
                            .resizable()
                            .frame(width: 48, height: 48) 
                    }
                }
            }
        }
        .accentColor(Color("Positive"))
    }
}
