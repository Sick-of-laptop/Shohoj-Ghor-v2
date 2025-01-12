import SwiftUI

struct SidebarView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isShowing = false
                    }
                }
            
            // Sidebar content
            HStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Menu")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(ColorTheme.text)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    isShowing = false
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(ColorTheme.navigation)
                                    .font(.title2)
                            }
                        }
                        
                        Rectangle()
                            .fill(ColorTheme.navigation.opacity(0.2))
                            .frame(height: 1)
                    }
                    .padding()
                    .background(ColorTheme.primary)
                    
                    // User Profile Section
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(ColorTheme.navigation)
                        
                        Text("John Doe")
                            .font(.headline)
                            .foregroundColor(ColorTheme.text)
                        
                        Text("john.doe@example.com")
                            .font(.subheadline)
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ColorTheme.background.opacity(0.5))
                    
                    // Menu Items
                    ScrollView {
                        VStack(spacing: 8) {
                            SidebarMenuItem(icon: "bag", title: "My Orders", count: "3")
                            SidebarMenuItem(icon: "heart", title: "Wishlist", count: "12")
                                                                                SidebarMenuItem(icon: "bell", title: "Notifications", count: "5")
                            SidebarMenuItem(icon: "info.circle", title: "About")
                            SidebarMenuItem(icon: "questionmark.circle", title: "Help & Support")
                            
                            Divider()
                                .padding(.vertical, 8)
                                .background(ColorTheme.primary)
                            
                            // Logout Button
                            Button(action: {
                                withAnimation {
                                    isShowing = false
                                    authViewModel.signOut()
                                }
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: "arrow.right.square")
                                        .font(.title3)
                                    Text("Logout")
                                        .font(.headline)
                                    Spacer()
                                }
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    
                    Spacer()
                    
                    // App Version
                    Text("Version 1.0.0")
                        .font(.caption)
                        .foregroundColor(ColorTheme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.bottom)
                }
                .frame(width: UIScreen.main.bounds.width * 0.75)
                .background(ColorTheme.primary)
                .edgesIgnoringSafeArea(.vertical)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: -5, y: 0)
            }
            .offset(x: isShowing ? 0 : UIScreen.main.bounds.width)
            .animation(.easeInOut(duration: 0.3), value: isShowing)
        }
    }
}

struct SidebarMenuItem: View {
    let icon: String
    let title: String
    var count: String? = nil
    
    var body: some View {
        Button(action: {
            // Handle menu item tap
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon + ".fill")
                    .font(.title3)
                    .frame(width: 24)
                    .foregroundColor(ColorTheme.navigation)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(ColorTheme.text)
                
                Spacer()
                
                if let count = count {
                    Text(count)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ColorTheme.navigation)
                        .clipShape(Capsule())
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(ColorTheme.primary)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SidebarView(isShowing: .constant(true))
} 
