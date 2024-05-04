import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var userModel: UserModel
    @StateObject var viewModel = ProgressViewModel() // Instead of @ObservedObject

    var body: some View {
        ScrollView {
            VStack(spacing: 95) {
                ForEach(viewModel.habits) { habit in
                    ProgressHabitCardView(habit: habit)
                }
            }
            .padding()
        }
        .navigationTitle("Progress")
        .onAppear {
            if let userID = userModel.userID {
                print("User ID retrieved in ProgressView: \(userID)")
                viewModel.configure(withUserID: userID)
            }
        }
           }
       }
