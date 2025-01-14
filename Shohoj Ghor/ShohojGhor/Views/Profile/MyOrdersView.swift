import SwiftUI

struct MyOrdersView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                if cartViewModel.orderHistory.isEmpty {
                    EmptyOrdersView()
                } else {
                    VStack(spacing: 20) {
                        ForEach(cartViewModel.orderHistory.sorted(by: { $0.date > $1.date })) { order in
                            OrderCard(order: order)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                }
            }
            .background(ColorTheme.background)
            .navigationTitle("My Orders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorTheme.navigation)
                            .font(.title3)
                    }
                }
            }
        }
    }
}

struct OrderCard: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Order Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.id.uuidString.prefix(8))")
                        .font(.headline)
                    
                    Text(formatDate(order.date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("$\(order.totalAmount, specifier: "%.2f")")
                    .fontWeight(.bold)
                    .foregroundColor(ColorTheme.navigation)
            }
            
            Divider()
            
            // Order Items
            ForEach(order.items) { item in
                HStack(spacing: 12) {
                    // Product Image
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(ColorTheme.secondaryText)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.product.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Quantity: \(item.quantity)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("$\(item.product.price * Double(item.quantity), specifier: "%.2f")")
                            .font(.caption)
                            .foregroundColor(ColorTheme.navigation)
                    }
                    
                    Spacer()
                }
            }
            
            // Order Status
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("Delivered")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct EmptyOrdersView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bag")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("No Orders Yet")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Your order history will appear here")
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
} 