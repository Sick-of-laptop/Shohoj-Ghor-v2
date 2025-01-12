import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                ColorTheme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Logo and Welcome Text
                    VStack(spacing: 20) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(ColorTheme.navigation)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                        
                        Text("Welcome Back!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(ColorTheme.text)
                        
                        Text("Sign in to continue")
                            .font(.subheadline)
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .offset(y: isAnimating ? 0 : -50)
                    
                    // Login Form
                    VStack(spacing: 24) {
                        CustomInputField(
                            imageName: "envelope",
                            placeholderText: "Email",
                            text: $email
                        )
                        .transition(.move(edge: .leading))
                        
                        CustomInputField(
                            imageName: "lock",
                            placeholderText: "Password",
                            isSecureField: true,
                            text: $password
                        )
                        .transition(.move(edge: .trailing))
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Forgot Password
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            // Handle forgot password
                        }
                        .foregroundColor(ColorTheme.navigation)
                    }
                    .padding(.horizontal)
                    
                    // Sign In Button
                    Button {
                        viewModel.login(withEmail: email, password: password)
                    } label: {
                        Text("Sign In")
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
                    
                    // Sign Up Link
                    NavigationLink {
                        RegistrationView()
                            .navigationBarHidden(true)
                            .environmentObject(viewModel)
                    } label: {
                        HStack {
                            Text("Don't have an account?")
                                .font(.footnote)
                                .foregroundColor(ColorTheme.text)
                            
                            Text("Sign Up")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorTheme.navigation)
                        }
                    }
                    .padding(.bottom, 32)
                }
                .padding()
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
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
    }
} 