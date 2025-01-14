import SwiftUI

struct ProductCard: View {
    let product: Product
    @EnvironmentObject var wishlistViewModel: WishlistViewModel
    @State private var showingWishlistAnimation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image and Wishlist Section
            ZStack(alignment: .topTrailing) {
                // Product Image with fixed aspect ratio
                AsyncImage(url: URL(string: product.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 150)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 150)
                            .cornerRadius(12)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(ColorTheme.secondaryText)
                            )
                    }
                }
                
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
                        .font(.system(size: 18))
                        .padding(6)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                }
                .padding(8)
            }
            
            // Product Info Section
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(ColorTheme.text)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(height: 36)
                
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTheme.navigation)
            }
            .padding(.horizontal, 8)
        }
        .padding(.bottom, 8)
        .frame(
            width: UIScreen.main.bounds.width * 0.45,
            height: 220
        )
        .background(ColorTheme.primary)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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