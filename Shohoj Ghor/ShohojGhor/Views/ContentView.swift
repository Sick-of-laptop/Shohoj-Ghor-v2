import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var selectedTab = 0
    @State private var showSidebar = false
    
    var body: some View {
        Group {
            if !authViewModel.isAuthenticated {
                LoginView()
            } else {
                mainInterfaceView
            }
        }
        .environmentObject(authViewModel)
    }
    
    var mainInterfaceView: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView(showSidebar: $showSidebar)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                
                NotificationsView()
                    .tabItem {
                        Image(systemName: "bell.fill")
                        Text("Notifications")
                    }
                    .tag(2)
                
                CartView()
                    .tabItem {
                        Image(systemName: "cart.fill")
                        Text("Cart")
                    }
                    .tag(3)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(4)
            }
            .accentColor(ColorTheme.navigation)
            
            if showSidebar {
                SidebarView(isShowing: $showSidebar)
                    .environmentObject(authViewModel)
                    .transition(.move(edge: .trailing))
            }
        }
        .background(ColorTheme.background)
    }
}

#Preview {
    ContentView()
} 