import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var userModel: UserModel
    @StateObject var viewModel = ProgressViewModel() 

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 95) {
                    ForEach(viewModel.habits) { habit in
                        NavigationLink(destination: ProgressHabitView(habit: habit)) {
                            ProgressHabitCardView(habit: habit)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                if let userID = userModel.userID {
                    print("User ID retrieved in ProgressView: \(userID)")
                    viewModel.configure(withUserID: userID)
                }
            }
        }
    }
}


