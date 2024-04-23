
import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showContentView = false
    @State private var showSignUpView = false

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Login") {
                    showContentView = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .navigationDestination(isPresented: $showContentView) {
                    ContentView()
                }

                Button("Sign Up") {
                    showSignUpView = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
                .navigationDestination(isPresented: $showSignUpView) {
                    SignUpView()
                }
            }
            .navigationTitle("Login")
        }
    }
}
