import SwiftUI

struct NotificationsView: View {
    @State private var notifications = [
        NotificationItem(type: .order, title: "Order Confirmed", message: "Your order #1234 has been confirmed", time: "2m ago"),
        NotificationItem(type: .delivery, title: "Out for Delivery", message: "Your order is on the way", time: "1h ago"),
        NotificationItem(type: .promo, title: "Special Offer", message: "Get 20% off on all furniture", time: "3h ago")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(notifications) { notification in
                    NotificationRow(notification: notification)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Notifications")
            .background(ColorTheme.background)
        }
    }
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let type: NotificationType
    let title: String
    let message: String
    let time: String
}

enum NotificationType {
    case order, delivery, promo
    
    var icon: String {
        switch self {
        case .order: return "bag.circle.fill"
        case .delivery: return "box.truck.fill"
        case .promo: return "tag.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .order: return ColorTheme.navigation
        case .delivery: return Color.green
        case .promo: return Color.purple
        }
    }
}

struct NotificationRow: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: notification.type.icon)
                .font(.title2)
                .foregroundColor(notification.type.color)
                .frame(width: 40, height: 40)
                .background(notification.type.color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(notification.message)
                    .font(.caption)
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(notification.time)
                    .font(.caption2)
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
        .padding(.vertical, 8)
    }
} 