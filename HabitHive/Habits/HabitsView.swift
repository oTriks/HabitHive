import SwiftUI
import Combine

struct HabitsView: View {
    @EnvironmentObject var userModel: UserModel
    @StateObject private var viewModel = HabitsViewModel()
    
    @State private var isShowingNewHabitView = false
    @State private var shouldDismissToHabits = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        
                        Spacer()
                    }
                    .padding(.vertical, 2)
                    .background(Color(UIColor.systemBackground))
                    .shadow(radius: 2)
                    
                    ScrollView {
                        VStack {
                            ForEach(viewModel.habits, id: \.id) { habit in
                                HabitCardView(habit: habit, viewModel: viewModel)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 80)
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        CustomFloatingActionButton(
                            action: { isShowingNewHabitView = true },
                            imageName: "plus"
                        )
                        .padding(20)
                        .shadow(radius: 4)
                    }
                }
            }
            .sheet(isPresented: $isShowingNewHabitView) {
                NewHabitView(
                    isPresented: $isShowingNewHabitView,
                    shouldDismissToHabits: $shouldDismissToHabits,
                    userModel: userModel
                )
            }
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
