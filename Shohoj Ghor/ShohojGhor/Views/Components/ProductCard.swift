import SwiftUI

struct ProductCard: View {
    let product: Product
    @EnvironmentObject var wishlistViewModel: WishlistViewModel
    @State private var showingWishlistAnimation = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                // Product Image
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(ColorTheme.secondaryText)
                    )
                
                // Wishlist Button
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        if wishlistViewModel.isInWishlist(product) {
                            wishlistViewModel.removeFromWishlist(product)
                        } else {
                            wishlistViewModel.addToWishlist(product)
                            showingWishlistAnimation = true
                        }
                    }
                } label: {
                    Image(systemName: wishlistViewModel.isInWishlist(product) ? "heart.fill" : "heart")
                        .foregroundColor(wishlistViewModel.isInWishlist(product) ? .red : .gray)
                        .font(.system(size: 20))
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(ColorTheme.text)
                    .lineLimit(2)
                
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(ColorTheme.navigation)
                
                if product.isNew {
                    Text("New")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(ColorTheme.primary)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .onChange(of: showingWishlistAnimation) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    showingWishlistAnimation = false
                }
            }
        }
    }
}

#Preview {
    ProductCard(product: Product(
        name: "Sample Product",
        price: 99.99,
        description: "Sample description",
        image: "photo",
        category: .furniture,
        isPopular: true,
        isNew: true
    ))
    .environmentObject(WishlistViewModel())
} 