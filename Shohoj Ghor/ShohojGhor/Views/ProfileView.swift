import SwiftUI

struct ProfileView: View {
    @State private var isEditMode = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(ColorTheme.navigation)
                        
                        Text("John Doe")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("john.doe@example.com")
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .padding()
                    
                    // Profile Sections
                    VStack(spacing: 16) {
                        ProfileSection(title: "My Orders", icon: "bag.fill")
                        ProfileSection(title: "Shipping Address", icon: "location.fill")
                        ProfileSection(title: "Payment Methods", icon: "creditcard.fill")
                        ProfileSection(title: "Settings", icon: "gear")
                        ProfileSection(title: "Help & Support", icon: "questionmark.circle.fill")
                    }
                    .padding()
                    
                    // Logout Button
                    Button(action: {
                        // Handle logout
                    }) {
                        Text("Logout")
                            .fontWeight(.medium)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Profile")
            .background(ColorTheme.background)
        }
    }
}

struct ProfileSection: View {
    let title: String
    let icon: String
    
    var body: some View {
        Button(action: {
            // Handle section tap
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(ColorTheme.navigation)
                    .frame(width: 30)
                
                Text(title)
                    .foregroundColor(ColorTheme.text)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding()
            .background(ColorTheme.primary)
            .cornerRadius(12)
        }
    }
} 