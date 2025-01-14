import SwiftUI

struct ProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var selectedImageIndex = 0
    @State private var quantity = 1
    @State private var showAddedToCart = false
    
    let product: Product
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image Carousel
                TabView(selection: $selectedImageIndex) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(ColorTheme.secondaryText)
                        )
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Product Info
                    Text(product.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title3)
                        .foregroundColor(ColorTheme.navigation)
                    
                    // Quantity Selector
                    HStack {
                        Text("Quantity")
                        Spacer()
                        HStack {
                            Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                Image(systemName: "minus.circle.fill")
                            }
                            Text("\(quantity)")
                                .frame(width: 40)
                            Button(action: { quantity += 1 }) {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        .foregroundColor(ColorTheme.navigation)
                    }
                    
                    // Description
                    Text("Description")
                        .font(.headline)
                    Text(product.description)
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    // Add to Cart Button
                    Button(action: {
                        cartViewModel.addToCart(product: product, quantity: quantity)
                        showAddedToCart = true
                        
                        // Dismiss after short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    }) {
                        Text("Add to Cart")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ColorTheme.navigation)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .overlay(
            // Success message
            ZStack {
                if showAddedToCart {
                    Text("Added to Cart")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(10)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: showAddedToCart)
        )
        .navigationBarTitleDisplayMode(.inline)
        .background(ColorTheme.background)
    }
}

// Preview provider
struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: Product(
            name: "Sample Product",
            price: 99.99,
            description: "Sample description",
            image: "photo",
            category: .furniture,
            isPopular: true,
            isNew: false
        ))
    }
} 
