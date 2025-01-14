import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var cartViewModel = CartViewModel()
    @State private var selectedTab = 0
    @State private var showSidebar = false
    
    var body: some View {
        ZStack {
            if authViewModel.isAuthenticated {
                TabView(selection: $selectedTab) {
                    HomeView(showSidebar: $showSidebar)
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .tag(0)
                    
                    SearchView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                        .tag(1)
                    
                    CartView()
                        .tabItem {
                            Image(systemName: "cart")
                            Text("Cart")
                        }
                        .tag(2)
                    
                    NotificationsView()
                        .tabItem {
                            Image(systemName: "bell")
                            Text("Notifications")
                        }
                        .tag(3)
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        .tag(4)
                }
                .tint(ColorTheme.navigation)
                
                if showSidebar {
                    SidebarView(showSidebar: $showSidebar)
                }
            } else {
                LoginView()
            }
        }
        .environmentObject(authViewModel)
        .environmentObject(cartViewModel)
    }
}

#Preview {
    ContentView()
} 