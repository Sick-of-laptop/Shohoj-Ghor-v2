import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showPayment = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if cartViewModel.cartItems.isEmpty {
                    EmptyCartView()
                } else {
                    VStack(spacing: 20) {
                        // Cart Items
                        ForEach(cartViewModel.cartItems) { item in
                            CartItemRow(item: item)
                                .environmentObject(cartViewModel)
                        }
                        
                        // Order Summary
                        VStack(spacing: 16) {
                            Text("Order Summary")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack {
                                Text("Total Amount")
                                Spacer()
                                Text("$\(cartViewModel.totalAmount, specifier: "%.2f")")
                                    .fontWeight(.bold)
                            }
                            
                            Button {
                                showPayment = true
                            } label: {
                                Text("Proceed to Checkout")
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(ColorTheme.navigation)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5)
                    }
                    .padding()
                }
            }
            .background(ColorTheme.background)
            .navigationTitle("Cart")
            .sheet(isPresented: $showPayment) {
                PaymentView()
            }
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Product Image
            AsyncImage(url: URL(string: item.product.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(ColorTheme.secondaryText)
                        )
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(item.product.name)
                    .font(.headline)
                
                Text("$\(item.product.price, specifier: "%.2f")")
                    .foregroundColor(ColorTheme.navigation)
                
                // Quantity Controls
                HStack {
                    Button {
                        cartViewModel.updateQuantity(for: item, newQuantity: item.quantity - 1)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                    }
                    
                    Text("\(item.quantity)")
                        .frame(width: 40)
                    
                    Button {
                        cartViewModel.updateQuantity(for: item, newQuantity: item.quantity + 1)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                .foregroundColor(ColorTheme.navigation)
            }
            
            Spacer()
            
            // Remove Button
            Button {
                cartViewModel.removeFromCart(item: item)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Browse our products and add items to your cart")
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
} 