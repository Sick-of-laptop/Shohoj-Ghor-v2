import SwiftUI

struct PopularItemsGridView: View {
    let products: [Product]
    @EnvironmentObject var wishlistViewModel: WishlistViewModel
    @State private var selectedProduct: Product?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(products) { product in
                    ProductCard(product: product)
                        .onTapGesture {
                            selectedProduct = product
                        }
                }
            }
            .padding(.horizontal)
        }
        .sheet(item: $selectedProduct) { product in
            ProductDetailView(product: product)
        }
    }
} 