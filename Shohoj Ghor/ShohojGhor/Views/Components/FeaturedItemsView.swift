import SwiftUI

struct FeaturedItemsView: View {
    let products: [Product]
    @State private var currentIndex = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            TabView(selection: $currentIndex) {
                ForEach(products.indices, id: \.self) { index in
                    FeaturedItemCard(product: products[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 300)
            .animation(.easeInOut, value: currentIndex)
        }
    }
}

struct FeaturedItemCard: View {
    let product: Product
    
    var body: some View {
        NavigationLink(destination: ProductDetailView(product: product)) {
            VStack(alignment: .leading) {
                // Product Image
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(ColorTheme.secondaryText)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.headline)
                        .foregroundColor(ColorTheme.text)
                    
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(ColorTheme.navigation)
                }
                .padding(.vertical, 8)
            }
            .background(ColorTheme.primary)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
        }
    }
} 