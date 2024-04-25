import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var navigationItem: NavigationItems? = nil
    @Published var errorMessage: String = ""

    init() {
        checkAutoLogin()
    }

    func checkAutoLogin() {
        if Auth.auth().currentUser != nil && UserDefaults.standard.bool(forKey: "rememberMe") {
            navigationItem = .contentView
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else if authResult?.user != nil {
                if self.rememberMe {
                    UserDefaults.standard.set(true, forKey: "rememberMe")
                } else {
                    UserDefaults.standard.set(false, forKey: "rememberMe")
                }
                self.navigationItem = .contentView
            } else {
                self.errorMessage = "Unknown error occurred"
            }
        }
    }
}
