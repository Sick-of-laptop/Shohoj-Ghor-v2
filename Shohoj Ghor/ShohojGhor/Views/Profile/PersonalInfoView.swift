import SwiftUI

struct PersonalInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var fullName: String = ""
    @State private var phone: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Personal Information Section
                    VStack(alignment: .leading, spacing: 20) {
                        SectionTitle(title: "Personal Information")
                        
                        CustomInputField(
                            imageName: "person",
                            placeholderText: "Full Name",
                            text: $fullName
                        )
                        
                        CustomInputField(
                            imageName: "phone",
                            placeholderText: "Phone Number",
                            text: $phone
                        )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    // Change Password Section
                    VStack(alignment: .leading, spacing: 20) {
                        SectionTitle(title: "Change Password")
                        
                        CustomInputField(
                            imageName: "lock",
                            placeholderText: "Current Password",
                            isSecureField: true,
                            text: $currentPassword
                        )
                        
                        CustomInputField(
                            imageName: "lock",
                            placeholderText: "New Password",
                            isSecureField: true,
                            text: $newPassword
                        )
                        
                        CustomInputField(
                            imageName: "lock",
                            placeholderText: "Confirm New Password",
                            isSecureField: true,
                            text: $confirmPassword
                        )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    // Save Button
                    Button {
                        updateUserInfo()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Save Changes")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(ColorTheme.navigation.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .shadow(color: ColorTheme.navigation.opacity(0.3), radius: 10, x: 0, y: 5)
                    .padding(.top)
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("Personal Information")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(ColorTheme.navigation)
                    }
                }
            }
        }
        .onAppear {
            if let user = authViewModel.currentUser {
                fullName = user.fullName
                phone = user.phone
            }
        }
        .alert("Update Info", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func updateUserInfo() {
        isLoading = true
        
        // Validate inputs
        guard !fullName.isEmpty else {
            showAlert(message: "Name cannot be empty")
            return
        }
        
        guard authViewModel.isValidPhone(phone) else {
            showAlert(message: "Please enter a valid phone number")
            return
        }
        
        // If password fields are not empty, validate password change
        if !currentPassword.isEmpty || !newPassword.isEmpty || !confirmPassword.isEmpty {
            guard !currentPassword.isEmpty else {
                showAlert(message: "Current password is required")
                return
            }
            
            guard authViewModel.isValidPassword(newPassword) else {
                showAlert(message: "New password must be at least 8 characters")
                return
            }
            
            guard newPassword == confirmPassword else {
                showAlert(message: "New passwords do not match")
                return
            }
        }
        
        // Update user information
        authViewModel.updateUserInfo(
            fullName: fullName,
            phone: phone,
            currentPassword: currentPassword,
            newPassword: newPassword
        ) { success, message in
            isLoading = false
            if success {
                showAlert(message: "Profile updated successfully")
                currentPassword = ""
                newPassword = ""
                confirmPassword = ""
            } else {
                showAlert(message: message)
            }
        }
    }
    
    private func showAlert(message: String) {
        isLoading = false
        alertMessage = message
        showAlert = true
    }
}

struct SectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.gray)
    }
} 