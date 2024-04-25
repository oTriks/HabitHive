
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var navigationItem: NavigationItems? = nil
    @State private var showSignUp = false
    @State private var errorMessage = ""
    @State private var loginSuccess = false

    
    var body: some View {
            NavigationStack {
                VStack {
                    Image("HabitHiveIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 5)
                    
                    Text("Log In")
                        .font(.title)
                        .padding(.bottom, 20)
                    
                    TextField("Email", text: $viewModel.username)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .modifier(ElevatedTextFieldStyle())
                    
                    SecureField("Password", text: $viewModel.password)
                        .modifier(ElevatedTextFieldStyle())
                    
                    HStack {
                        Spacer()
                        Checkbox(isChecked: $viewModel.rememberMe, label: "Remember me")
                    }
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    HStack {
                        CustomButton(text: "Sign Up", backgroundColor: Color("button")) {
                            viewModel.navigationItem = .signUpView
                        }
                        CustomButton(text: "Log In", backgroundColor: Color("button")) {
                            viewModel.login()
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                
                
                            
                                NavigationLink(destination: SignUpView(), tag: .signUpView, selection: $viewModel.navigationItem) {
                                    EmptyView()
                                }
                                
                                NavigationLink(destination: ContentView(), tag: .contentView, selection: $viewModel.navigationItem) {
                                    EmptyView()
                                }
                            }
                
                                .onAppear {
                                                viewModel.checkAutoLogin()
                                            
            
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
