import SwiftUI

struct CartView: View {
    @State private var cartItems = [
        CartItem(name: "Modern Sofa", price: 599.0, quantity: 1),
        CartItem(name: "Table Lamp", price: 79.0, quantity: 2)
    ]
    
    var totalAmount: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if cartItems.isEmpty {
                    EmptyCartView()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(cartItems) { item in
                                CartItemRow(item: item)
                            }
                            
                            // Order Summary
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Subtotal")
                                    Spacer()
                                    Text("$\(totalAmount, specifier: "%.2f")")
                                }
                                
                                HStack {
                                    Text("Delivery")
                                    Spacer()
                                    Text("$10.00")
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Total")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("$\(totalAmount + 10.0, specifier: "%.2f")")
                                        .fontWeight(.bold)
                                }
                            }
                            .padding()
                            .background(ColorTheme.primary)
                            .cornerRadius(12)
                            .padding()
                            
                            // Checkout Button
                            Button(action: {
                                // Handle checkout
                            }) {
                                Text("Proceed to Checkout")
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(ColorTheme.navigation)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Cart")
            .background(ColorTheme.background)
        }
    }
}

struct CartItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    var quantity: Int
}

struct CartItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 16) {
            // Product Image
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("$\(item.price, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(ColorTheme.navigation)
                
                HStack {
                    Text("Quantity: \(item.quantity)")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Button(action: {
                // Remove item
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(ColorTheme.primary)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct EmptyCartView: View {
    @State private var showSidebar = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart.badge.minus")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("Your cart is empty")
                .font(.title3)
                .fontWeight(.medium)
            
            Text("Browse our collection and add items to your cart")
                .font(.subheadline)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            NavigationLink(destination: HomeView(showSidebar: $showSidebar)) {
                Text("Start Shopping")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding()
                    .background(ColorTheme.navigation)
                    .cornerRadius(12)
            }
        }
    }
} 