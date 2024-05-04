import SwiftUI
import Combine

struct HabitsView: View {
    @EnvironmentObject var userModel: UserModel
    @StateObject private var viewModel = HabitsViewModel()

    @State private var isShowingNewHabitView = false
    @State private var shouldDismissToHabits = false

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
                    action: { isShowingNewHabitView = true },
                    imageName: "plus"
                )
                .padding(20)
                .shadow(radius: 4)
                .sheet(isPresented: $isShowingNewHabitView) {
                    NewHabitView(
                        isPresented: $isShowingNewHabitView,
                        shouldDismissToHabits: $shouldDismissToHabits,
                        userModel: userModel
                    )
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if let userID = userModel.userID {
                    viewModel.configure(withUserID: userID)
                } else {
                    print("User ID is nil")
                }
            }
        }
    }
}




struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        let userModel = UserModel() // Provide a UserModel instance here
        let viewModel = HabitsViewModel() // Provide a HabitsViewModel instance here
        return HabitsView()
            .environmentObject(userModel)
            .environmentObject(viewModel)
    }
}
