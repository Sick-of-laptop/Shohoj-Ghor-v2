import SwiftUI

struct PopularItemsGridView: View {
    let products: [Product]
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(products) { product in
                    PopularItemCard(product: product)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct PopularItemCard: View {
    let product: Product
    
    var body: some View {
        NavigationLink(destination: ProductDetailView(product: product)) {
            VStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(ColorTheme.secondaryText)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(ColorTheme.text)
                    
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundColor(ColorTheme.navigation)
                }
                .padding(.vertical, 8)
            }
            .background(ColorTheme.primary)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
} 