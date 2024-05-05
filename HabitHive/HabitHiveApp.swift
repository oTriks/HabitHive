import SwiftUI
import FirebaseCore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        print("Firebase configured successfully.")

        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
        }

        // Set the notification center delegate (optional)
        UNUserNotificationCenter.current().delegate = self

        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert, .badge]) // Show alerts even if the app is open
    }
}


@main
struct HabitHiveApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userModel = UserModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()
            }
            .environmentObject(userModel)  
        }
    }
}
