import SwiftUI


struct HabitsView: View {
    @StateObject private var viewModel = HabitsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.habits, id: \.id) { habit in
                            HabitCardView(habit: habit)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .background(Color.gray.opacity(0.1)) // Optional background color for the scroll view

                // Floating Action Button
                CustomFloatingActionButton(
                    action: { viewModel.addNewHabit() },
                    imageName: "plus"
                )
                .padding(20) // Adjust padding to ensure visibility and accessibility
                .shadow(radius: 4) // Optional: adds subtle shadow for better visibility
                .sheet(isPresented: $viewModel.isAddingNewHabit) {
                    NewHabitView(viewModel: NewHabitViewModel())
                }
            }
            .navigationBarHidden(true)
        }
    }
}






// Preview provider
struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
    }
}
