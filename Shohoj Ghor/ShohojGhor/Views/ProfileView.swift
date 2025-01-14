import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showPersonalInfo = false
    @State private var showMyOrders = false
    @State private var showWishlist = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Profile Header
                    if let user = authViewModel.currentUser {
                        ProfileHeader(user: user)
                    }
                    
                    // Quick Stats
                    HStack(spacing: 20) {
                        ProfileStatCard(title: "Orders", value: "12", icon: "bag.fill")
                        ProfileStatCard(title: "Wishlist", value: "5", icon: "heart.fill")
                        ProfileStatCard(title: "Reviews", value: "8", icon: "star.fill")
                    }
                    .padding(.horizontal)
                    
                    // Profile Sections
                    VStack(spacing: 16) {
                        ProfileMenuSection(title: "Shopping", items: [
                            MenuItem(title: "My Orders", icon: "bag.fill", color: .blue),
                            MenuItem(title: "My Wishlist", icon: "heart.fill", color: .red),
                            MenuItem(title: "My Reviews", icon: "star.fill", color: .yellow)
                        ], showPersonalInfo: $showPersonalInfo, showMyOrders: $showMyOrders, showWishlist: $showWishlist)
                        
                        ProfileMenuSection(title: "Account", items: [
                            MenuItem(title: "Personal Info", icon: "person.fill", color: .green),
                            MenuItem(title: "Addresses", icon: "location.fill", color: .purple),
                            MenuItem(title: "Payment Methods", icon: "creditcard.fill", color: .orange)
                        ], showPersonalInfo: $showPersonalInfo, showMyOrders: $showMyOrders, showWishlist: $showWishlist)
                        
                        ProfileMenuSection(title: "Support", items: [
                            MenuItem(title: "Help Center", icon: "questionmark.circle.fill", color: .blue),
                            MenuItem(title: "Contact Us", icon: "message.fill", color: .green)
                        ], showPersonalInfo: $showPersonalInfo, showMyOrders: $showMyOrders, showWishlist: $showWishlist)
                    }
                    .padding(.horizontal)
                    
                    // Logout Button
                    Button {
                        authViewModel.signOut()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                            Text("Logout")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red.gradient)
                        .cornerRadius(25)
                        .shadow(color: .red.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showMyOrders) {
                MyOrdersView()
            }
            .sheet(isPresented: $showWishlist) {
                WishlistView()
            }
            .sheet(isPresented: $showPersonalInfo) {
                PersonalInfoView()
            }
        }
    }
}

struct ProfileHeader: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 15) {
            // Profile Image
            ZStack {
                Circle()
                    .fill(ColorTheme.navigation.gradient)
                    .frame(width: 110, height: 110)
                    .shadow(color: ColorTheme.navigation.opacity(0.3), radius: 10)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 45))
                    .foregroundColor(.white)
            }
            
            // User Info
            VStack(spacing: 8) {
                Text(user.fullName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(user.phone)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10)
        .padding(.horizontal)
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(ColorTheme.navigation)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
}

struct ProfileMenuSection: View {
    let title: String
    let items: [MenuItem]
    @Binding var showPersonalInfo: Bool
    @Binding var showMyOrders: Bool
    @Binding var showWishlist: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.leading, 5)
            
            VStack(spacing: 5) {
                ForEach(items) { item in
                    Button {
                        switch item.title {
                        case "Personal Info":
                            showPersonalInfo = true
                        case "My Orders":
                            showMyOrders = true
                        case "My Wishlist":
                            showWishlist = true
                        default:
                            break
                        }
                    } label: {
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundColor(item.color)
                                .frame(width: 30)
                            
                            Text(item.title)
                                .foregroundColor(ColorTheme.text)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
} 