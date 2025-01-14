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
                            .disabled(cartViewModel.cartItems.isEmpty)
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
    @State private var quantity: Int
    @State private var imageURL: URL?
    
    init(item: CartItem) {
        self.item = item
        _quantity = State(initialValue: item.quantity)
        _imageURL = State(initialValue: URL(string: item.product.image))
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Product Image
            Group {
                if let url = imageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure(_):
                            Image(systemName: "photo")
                                .foregroundColor(ColorTheme.secondaryText)
                                .background(Color.gray.opacity(0.2))
                        case .empty:
                            ProgressView()
                        @unknown default:
                            Image(systemName: "photo")
                                .foregroundColor(ColorTheme.secondaryText)
                                .background(Color.gray.opacity(0.2))
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "photo")
                        .foregroundColor(ColorTheme.secondaryText)
                        .frame(width: 80, height: 80)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(item.product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text("$\(item.product.price, specifier: "%.2f")")
                    .foregroundColor(ColorTheme.navigation)
                
                // Quantity Controls
                HStack {
                    Button {
                        if quantity > 1 {
                            quantity -= 1
                            cartViewModel.updateQuantity(for: item, newQuantity: quantity)
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(quantity > 1 ? ColorTheme.navigation : Color.gray)
                    }
                    .disabled(quantity <= 1)
                    
                    Text("\(quantity)")
                        .frame(width: 40)
                        .font(.headline)
                    
                    Button {
                        quantity += 1
                        cartViewModel.updateQuantity(for: item, newQuantity: quantity)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(ColorTheme.navigation)
                    }
                }
                .padding(.vertical, 4)
            }
            
            Spacer()
            
            // Remove Button
            Button {
                withAnimation {
                    cartViewModel.removeFromCart(item: item)
                }
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .onAppear {
            // Ensure URL is valid when view appears
            if imageURL == nil {
                imageURL = URL(string: item.product.image)
            }
        }
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