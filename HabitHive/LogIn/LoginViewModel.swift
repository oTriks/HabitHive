import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var navigationItem: NavigationItems? = nil
    @Published var errorMessage: String = ""
    var userModel: UserModel?  // Make optional if needed

    

    func login() {
            guard let userModel = userModel else {
                print("UserModel not set.")
                return
            }
            Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else if let user = authResult?.user {
                    if self.rememberMe {
                        UserDefaults.standard.set(true, forKey: "rememberMe")
                    } else {
                        UserDefaults.standard.set(false, forKey: "rememberMe")
                    }
                    self.navigationItem = .contentView
                    userModel.userID = user.uid
                    print("Logged in User ID: \(user.uid)")
                } else {
                    self.errorMessage = "Unknown error occurred"
                }
            }
        }
    }

