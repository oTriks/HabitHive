import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase configured successfully.")
        return true
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
