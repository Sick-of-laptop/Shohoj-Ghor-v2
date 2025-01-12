import SwiftUI

struct AdminLoginView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showAdminLogin: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var navigateToAdminPanel = false
    
    // Hardcoded admin credentials
    private let adminEmail = "admin@gmail.com"
    private let adminPassword = "admin123"
    
    var body: some View {
        ZStack {
            ColorTheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Admin Login")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.text)
                
                VStack(spacing: 24) {
                    CustomInputField(
                        imageName: "envelope",
                        placeholderText: "Admin Email",
                        text: $email
                    )
                    .textInputAutocapitalization(.never)
                    
                    CustomInputField(
                        imageName: "lock",
                        placeholderText: "Admin Password",
                        isSecureField: true,
                        text: $password
                    )
                }
                .padding(.horizontal)
                
                Button {
                    authenticateAdmin()
                } label: {
                    Text("Admin Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorTheme.navigation)
                        .cornerRadius(25)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(ColorTheme.navigation)
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .fullScreenCover(isPresented: $navigateToAdminPanel) {
            AdminPanelView(showAdminLogin: $showAdminLogin)
        }
    }
    
    private func authenticateAdmin() {
        if email == adminEmail && password == adminPassword {
            navigateToAdminPanel = true
        } else {
            errorMessage = "Invalid admin credentials"
            showError = true
        }
    }
} 