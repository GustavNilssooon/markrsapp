import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                
                Text(isLogin ? "Welcome Back!" : "Create Account")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    if !isLogin {
                        TextField("Full Name", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                    }
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: performAction) {
                    Text(isLogin ? "Sign In" : "Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: { isLogin.toggle() }) {
                    Text(isLogin ? "Need an account? Sign Up" : "Already have an account? Sign In")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    private func performAction() {
        if isLogin {
            authViewModel.signIn(email: email, password: password)
        } else {
            authViewModel.signUp(email: email, password: password, fullName: fullName)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(AuthViewModel())
    }
} 