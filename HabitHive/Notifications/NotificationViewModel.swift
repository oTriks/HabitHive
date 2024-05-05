import Foundation
import FirebaseFirestore
import Combine

class NotificationViewModel: ObservableObject {
    @Published var notifications: [UserNotification] = []
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    init() {
        fetchNotifications()
    }

    // Fetch notifications from Firestore
    func fetchNotifications() {
        listenerRegistration = db.collection("notifications").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents in 'notifications' collection")
                return
            }

            // Fetch all notifications and decode them
            self.notifications = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: UserNotification.self)
            }
        }
    }

    // Add a new notification to Firestore
    func addNotification(_ notification: UserNotification) {
        do {
            _ = try db.collection("notifications").addDocument(from: notification)
        } catch {
            print("Error adding notification to Firestore: \(error.localizedDescription)")
        }
    }

    // Remove a notification from Firestore
    func removeNotification(withId id: String) {
        db.collection("notifications").whereField("id", isEqualTo: id).getDocuments { snapshot, error in
            if let error = error {
                print("Error finding document to remove: \(error.localizedDescription)")
                return
            }

            snapshot?.documents.first?.reference.delete { error in
                if let error = error {
                    print("Error deleting document: \(error.localizedDescription)")
                }
            }
        }
    }

    deinit {
        listenerRegistration?.remove()
    }
}
