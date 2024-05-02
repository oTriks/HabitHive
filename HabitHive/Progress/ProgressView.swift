import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var userModel: UserModel
    @ObservedObject var viewModel = ProgressViewModel()

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
                   // Check if the userModel.userID is retrieved
                   if let userID = userModel.userID {
                       print("User ID retrieved in ProgressView: \(userID)")
                       viewModel.configure(withUserID: userID)
                   } else {
                       print("User ID not retrieved in ProgressView")
                   }
               }
           }
       }
