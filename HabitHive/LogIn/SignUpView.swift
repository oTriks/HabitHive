import SwiftUI
import Firebase

struct SignUpView: View {

    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) var dismiss
    
    
var body: some View {
    NavigationStack {
        VStack {
            Image("HabitHiveIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.bottom, 5)

            Text(NSLocalizedString("sign_up", comment: "Sign up text"))
                .font(.title)
                .padding(.bottom, 20)

            TextField(NSLocalizedString("username", comment: "Placeholder text username input field"), text: $viewModel.username)
                .modifier(ElevatedTextFieldStyle())

            SecureField(NSLocalizedString("password", comment: "Placeholder text password input field"), text: $viewModel.password)
                .modifier(ElevatedTextFieldStyle())
            SecureField(NSLocalizedString("re_password", comment: "Placeholder text re-password input field"), text: $viewModel.rePassword)
                .modifier(ElevatedTextFieldStyle())

            HStack {
                CustomButton(text: NSLocalizedString("cancel", comment: "Cancel button text"), backgroundColor: Color("button")) {
                    dismiss()
                }
                
                CustomButton(text: NSLocalizedString("sign_up", comment: "Sign up button text"), backgroundColor: Color("button")) {
                    viewModel.registerUser { success, userID in
                                            if success {
                                                dismiss()
                                            } else {
                                                print("Registration failed")
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
        }
    }
}
}




struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro"))
    }
}
