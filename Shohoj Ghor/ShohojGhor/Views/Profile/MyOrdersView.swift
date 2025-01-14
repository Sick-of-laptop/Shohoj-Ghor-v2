import SwiftUI

struct MyOrdersView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MyOrderViewModel()
    @State private var showAnimation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let error = viewModel.error {
                    ErrorView(message: error, retryAction: {
                        viewModel.refreshOrders()
                    })
                } else if viewModel.orders.isEmpty {
                    EmptyOrdersView()
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.orders) { order in
                                OrderCard(order: order, viewModel: viewModel)
                                    .transition(.scale.combined(with: .opacity))
                                    .opacity(showAnimation ? 1 : 0)
                                    .offset(y: showAnimation ? 0 : 50)
                                    .animation(
                                        .spring(response: 0.5, dampingFraction: 0.8)
                                        .delay(Double(viewModel.orders.firstIndex(where: { $0.id == order.id }) ?? 0) * 0.1),
                                        value: showAnimation
                                    )
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        viewModel.refreshOrders()
                    }
                }
            }
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
        .onAppear {
            withAnimation {
                showAnimation = true
            }
        }
        .onDisappear {
            showAnimation = false
        }
    }
}

struct OrderCard: View {
    let order: Order
    let viewModel: MyOrderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Order Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Order #\(order.id.prefix(8))")
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
                OrderItemRow(item: item)
            }
            
            // Order Status
            let (status, color) = viewModel.getOrderStatus(order)
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(color)
                Text(status)
                    .font(.caption)
                    .foregroundColor(color)
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

struct OrderItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.product.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(_):
                    Image(systemName: "photo")
                        .foregroundColor(ColorTheme.secondaryText)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
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
}

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Error")
                .font(.headline)
                .foregroundColor(.red)
            
            Text(message)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("Retry")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(ColorTheme.navigation)
                    .cornerRadius(8)
            }
        }
        .padding()
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