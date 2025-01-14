import SwiftUI

struct WishlistView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var wishlistViewModel: WishlistViewModel
    @State private var selectedProduct: Product?
    @State private var showAnimation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if wishlistViewModel.wishlistItems.isEmpty {
                    EmptyWishlistView()
                } else {
                    VStack(spacing: 16) {
                        ForEach(wishlistViewModel.wishlistItems) { product in
                            WishlistItemCard(product: product)
                                .onTapGesture {
                                    selectedProduct = product
                                }
                                .opacity(showAnimation ? 1 : 0)
                                .offset(y: showAnimation ? 0 : 50)
                                .animation(
                                    .spring(response: 0.5, dampingFraction: 0.8)
                                    .delay(Double(wishlistViewModel.wishlistItems.firstIndex(where: { $0.id == product.id }) ?? 0) * 0.1),
                                    value: showAnimation
                                )
                        }
                    }
                    .padding()
                }
            }
            .background(ColorTheme.background)
            .navigationTitle("My Wishlist")
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
            .sheet(item: $selectedProduct) { product in
                ProductDetailView(product: product)
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

struct WishlistItemCard: View {
    let product: Product
    @EnvironmentObject var wishlistViewModel: WishlistViewModel
    @State private var isRemoving = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Product Image
            if let url = URL(string: product.image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(ColorTheme.secondaryText)
                        )
                }
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(ColorTheme.secondaryText)
                    )
            }
            
            // Product Info
            VStack(alignment: .leading, spacing: 8) {
                Text(product.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(ColorTheme.navigation)
                    .fontWeight(.semibold)
                
                HStack {
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
                    
                    Spacer()
                    
                    // Remove Button
                    Button {
                        withAnimation {
                            isRemoving = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                wishlistViewModel.removeFromWishlist(product)
                            }
                        }
                    } label: {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .scaleEffect(isRemoving ? 0.8 : 1)
        .opacity(isRemoving ? 0 : 1)
    }
}

struct EmptyWishlistView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 70))
                .foregroundColor(ColorTheme.navigation)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            Text("Your wishlist is empty")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Save items you love to your wishlist")
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            NavigationLink(destination: HomeView(showSidebar: .constant(false))) {
                Text("Start Shopping")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(ColorTheme.navigation.gradient)
                    .cornerRadius(25)
                    .shadow(color: ColorTheme.navigation.opacity(0.3), radius: 10)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
            }
        }
        .padding()
        .frame(maxHeight: .infinity)
        .onAppear {
            isAnimating = true
        }
    }
}