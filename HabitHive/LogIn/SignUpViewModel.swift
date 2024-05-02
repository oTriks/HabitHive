import Foundation
import Firebase

class SignUpViewModel: ObservableObject {
    private var db = Firestore.firestore()

    @Published var username: String = ""
    @Published var password: String = ""
    @Published var rePassword: String = ""
    
    func registerUser(completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if let error = error {
                print("Error registering user: \(error)")
                completion(false, nil)
            } else if let authResult = authResult {
                print("User registered successfully")
                // Now you can access the userID like this:
                let userID = authResult.user.uid
                // Optionally, store additional user data in Firestore
                self.db.collection("users").document(userID).setData([
                    "username": self.username
                ])
                completion(true, userID)
            }
        }
    }

}
