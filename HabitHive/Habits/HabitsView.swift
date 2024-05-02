import SwiftUI
import Combine


struct HabitsView: View {
    @EnvironmentObject var userModel: UserModel // Access the shared user model

    @StateObject private var viewModel = HabitsViewModel()
    @State private var isAddingNewHabit = false
    @State private var isShowingNewHabitView = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.habits, id: \.id) { habit in
                            HabitCardView(habit: habit, viewModel: viewModel)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .background(Color.gray.opacity(0.1))
                
                CustomFloatingActionButton(
                    action: { isAddingNewHabit = true },
                    imageName: "plus"
                )
                .padding(20)
                .shadow(radius: 4)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isAddingNewHabit) {
                NewHabitView(isPresented: $isAddingNewHabit, shouldDismissToHabits: $isShowingNewHabitView, userModel: userModel) 

            }
            .onReceive(Just(isShowingNewHabitView)) { newValue in
                if !newValue {
                    isAddingNewHabit = false
                }
            }
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
