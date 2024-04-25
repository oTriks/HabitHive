import Foundation
import Firebase

class SignUpViewModel: ObservableObject {
    private var db = Firestore.firestore()

    @Published var username: String = ""
    @Published var password: String = ""
    @Published var rePassword: String = ""
    
    func registerUser(completion: @escaping (Bool) -> Void) {
        guard password == rePassword, !username.isEmpty, !password.isEmpty else {
            completion(false)
            return
        }

        db.collection("users").addDocument(data: [
            "username": username,
            "password": password
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(false)
            } else {
                print("User registered successfully")
                completion(true) 
            }
        }
    }
}
