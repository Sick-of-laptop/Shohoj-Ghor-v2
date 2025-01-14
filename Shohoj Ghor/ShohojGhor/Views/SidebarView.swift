import SwiftUI

struct SidebarView: View {
    @Binding var showSidebar: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSpecFinder = false
    
    var body: some View {
        ZStack {
            // Blur background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showSidebar.toggle()
                    }
                }
            
            // Sidebar content
            HStack {
                VStack(alignment: .leading, spacing: 32) {
                    // User Profile Section
                    VStack(alignment: .leading, spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(ColorTheme.navigation)
                        
                        if let user = authViewModel.currentUser {
                            Text(user.fullName)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorTheme.text)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(ColorTheme.secondaryText)
                        } else {
                            Text("Welcome Guest")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorTheme.text)
                            
                            Button {
                                // Navigate to login
                                showSidebar = false
                                // Add your login navigation logic here
                            } label: {
                                Text("Sign In")
                                    .font(.subheadline)
                                    .foregroundColor(ColorTheme.navigation)
                            }
                        }
                    }
                    .padding(.top, 40)
                    
                    // Menu Items
                    VStack(alignment: .leading, spacing: 24) {
                        MenuLink(title: "Home", icon: "house.fill")
                        MenuLink(title: "Categories", icon: "square.grid.2x2.fill")
                        MenuLink(title: "My Orders", icon: "bag.fill")
                        MenuLink(title: "Favorites", icon: "heart.fill")
                        MenuLink(title: "Settings", icon: "gear")
                        MenuLink(title: "Help & Support", icon: "questionmark.circle.fill")
                        MenuButton(
                            title: "Specification Finder",
                            icon: "magnifyingglass",
                            action: { showSpecFinder = true }
                        )
                    }
                    
                    Spacer()
                    
                    // Logout Button (only show when user is logged in)
                    if authViewModel.currentUser != nil {
                        Button {
                            authViewModel.signOut()
                            showSidebar = false
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.left.square.fill")
                                    .font(.title3)
                                Text("Logout")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.red)
                        }
                        .padding(.bottom, 40)
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                .background(ColorTheme.background)
                .ignoresSafeArea()
                
                Spacer()
            }
            .offset(x: showSidebar ? 0 : -UIScreen.main.bounds.width)
        }
        .sheet(isPresented: $showSpecFinder) {
            SpecificationFinderView()
        }
    }
}

struct MenuLink: View {
    let title: String
    let icon: String
    
    var body: some View {
        Button(action: {
            // Handle menu item tap
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .fontWeight(.medium)
            }
            .foregroundColor(ColorTheme.text)
        }
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .fontWeight(.medium)
            }
            .foregroundColor(ColorTheme.text)
        }
    }
}

#Preview {
    SidebarView(showSidebar: .constant(true))
} 
