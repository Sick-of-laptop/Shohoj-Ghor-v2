import SwiftUI

struct RegistrationView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var fullName = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            ColorTheme.background
                .ignoresSafeArea()
            
            VStack {
                // Back Button
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(ColorTheme.navigation)
                    }
                    
                    Spacer()
                }
                .padding()
                
                // Title
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(ColorTheme.text)
                    
                    Text("Please fill in the form to continue")
                        .font(.subheadline)
                        .foregroundColor(ColorTheme.secondaryText)
                }
                .padding(.bottom, 30)
                .offset(y: isAnimating ? 0 : -30)
                
                // Registration Form
                VStack(spacing: 24) {
                    Group {
                        CustomInputField(
                            imageName: "person",
                            placeholderText: "Full Name",
                            text: $fullName
                        )
                        
                        CustomInputField(
                            imageName: "envelope",
                            placeholderText: "Email",
                            text: $email
                        )
                        
                        CustomInputField(
                            imageName: "phone",
                            placeholderText: "Phone",
                            text: $phone
                        )
                        
                        CustomInputField(
                            imageName: "lock",
                            placeholderText: "Password",
                            isSecureField: true,
                            text: $password
                        )
                        
                        CustomInputField(
                            imageName: "lock",
                            placeholderText: "Confirm Password",
                            isSecureField: true,
                            text: $confirmPassword
                        )
                    }
                    .offset(x: isAnimating ? 0 : -UIScreen.main.bounds.width)
                }
                .padding(.horizontal)
                
                // Sign Up Button
                Button {
                    guard password == confirmPassword else {
                        viewModel.errorMessage = "Passwords do not match"
                        viewModel.showError = true
                        return
                    }
                    viewModel.register(
                        withEmail: email,
                        password: password,
                        fullName: fullName,
                        phone: phone
                    )
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorTheme.navigation)
                        .cornerRadius(25)
                        .shadow(color: ColorTheme.navigation.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal)
                .padding(.top, 24)
                
                Spacer()
                
                // Sign In Link
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                            .foregroundColor(ColorTheme.text)
                        
                        Text("Sign In")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorTheme.navigation)
                    }
                }
                .padding(.bottom, 32)
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        }
        .overlay(
            LoadingView()
                .opacity(viewModel.isLoading ? 1 : 0)
        )
        .overlay(
            ZStack {
                if viewModel.showSuccess {
                    Text(viewModel.successMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(10)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: viewModel.showSuccess)
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
} 