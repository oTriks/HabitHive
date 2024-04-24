
import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var navigationItem: NavigationItems? = nil
    @State private var rememberMe = false
    @State private var showSignUp = false

    
    var body: some View {
        NavigationStack {
            VStack {
                Image("HabitHiveIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 5)
                
                Text(NSLocalizedString("log_in", comment: "Log in text"))
                    .font(.title)
                    .padding(.bottom, 20)
                
                TextField(NSLocalizedString("username", comment: "Placeholder text username input field"), text: $username)
                    .modifier(ElevatedTextFieldStyle())
                
                SecureField(NSLocalizedString("password", comment: "Placeholder text password input field"), text: $password)
                    .modifier(ElevatedTextFieldStyle())
                
                HStack {
                    Spacer()
                    Checkbox(isChecked: $rememberMe, label: "Remember me")
                }
                
                HStack {
                    CustomButton(text: NSLocalizedString("sign_up", comment: "Sign up button text"), backgroundColor: Color("button")) {
                        showSignUp = true

                    }
                  
            
                    CustomButton(text: NSLocalizedString("log_in", comment: "Login button text"), backgroundColor: Color("button")) {
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                
                 NavigationLink(destination: SignUpView(), isActive: $showSignUp) {
                     EmptyView()
                 }
                
                
            
            }
        }
    }
}


// Preview provider
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
    }
}
