import Foundation

class UserModel: ObservableObject {
    @Published var userID: String?

    init(userID: String? = nil) {
        self.userID = userID
    }
}
