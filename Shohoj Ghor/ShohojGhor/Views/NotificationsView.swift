import SwiftUI

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationViewModel()
    @State private var selectedNotification: AppNotification?
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.notifications.isEmpty {
                    EmptyNotificationsView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.notifications) { notification in
                                NotificationCard(notification: notification)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedNotification = notification
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(ColorTheme.background)
            .navigationTitle("Notifications")
            .sheet(item: $selectedNotification) { notification in
                NotificationDetailView(notification: notification)
            }
        }
    }
}

struct NotificationCard: View {
    let notification: AppNotification
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Circle()
                .fill(iconBackground)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: iconName)
                        .foregroundColor(.white)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(notification.isRead ? .gray : .primary)
                
                Text(timeAgo(from: notification.timestamp))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if !notification.isRead {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .transition(.scale.combined(with: .opacity))
    }
    
    private var iconName: String {
        switch notification.type {
        case .orderSuccess: return "bag.fill"
        case .newProduct: return "star.fill"
        case .promotion: return "tag.fill"
        case .system: return "bell.fill"
        }
    }
    
    private var iconBackground: Color {
        switch notification.type {
        case .orderSuccess: return .green
        case .newProduct: return .blue
        case .promotion: return .orange
        case .system: return .gray
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct NotificationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let notification: AppNotification
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Circle()
                            .fill(getIconBackground(for: notification.type))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: getIconName(for: notification.type))
                                    .foregroundColor(.white)
                                    .font(.title2)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(getTitle(for: notification.type))
                                .font(.headline)
                            
                            Text(timeAgo(from: notification.timestamp))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Message
                    Text(notification.message)
                        .font(.body)
                        .padding(.top)
                }
                .padding()
            }
            .background(ColorTheme.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorTheme.navigation)
                    }
                }
            }
        }
    }
    
    private func getTitle(for type: NotificationType) -> String {
        switch type {
        case .orderSuccess: return "Order Update"
        case .newProduct: return "New Product"
        case .promotion: return "Special Offer"
        case .system: return "System Update"
        }
    }
    
    private func getIconName(for type: NotificationType) -> String {
        switch type {
        case .orderSuccess: return "bag.fill"
        case .newProduct: return "star.fill"
        case .promotion: return "tag.fill"
        case .system: return "bell.fill"
        }
    }
    
    private func getIconBackground(for type: NotificationType) -> Color {
        switch type {
        case .orderSuccess: return .green
        case .newProduct: return .blue
        case .promotion: return .orange
        case .system: return .gray
        }
    }
    
    private func timeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct EmptyNotificationsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.slash")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("No Notifications")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("You're all caught up!")
                .foregroundColor(ColorTheme.secondaryText)
        }
        .frame(maxHeight: .infinity)
    }
} 