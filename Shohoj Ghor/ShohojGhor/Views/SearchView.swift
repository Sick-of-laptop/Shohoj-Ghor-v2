import SwiftUI

struct SearchView: View {
    @StateObject private var productViewModel = ProductViewModel()
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    let filters = ["All", "Furniture", "Appliances", "Decor", "Kitchen"]
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return productViewModel.products
        } else {
            return productViewModel.products.filter { product in
                product.name.lowercased().contains(searchText.lowercased()) ||
                product.description.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    TextField("Search items...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                }
                .padding()
                .background(ColorTheme.primary)
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filters, id: \.self) { filter in
                            FilterChip(
                                title: filter,
                                isSelected: selectedFilter == filter,
                                action: { selectedFilter = filter }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Search Results
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(filteredProducts) { product in
                            SearchResultCard(product: product)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Search")
            .background(ColorTheme.background)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? ColorTheme.navigation : ColorTheme.primary)
                .foregroundColor(isSelected ? .white : ColorTheme.text)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
    }
}

struct SearchResultCard: View {
    let product: Product
    
    var body: some View {
        NavigationLink(destination: ProductDetailView(product: product)) {
            VStack(alignment: .leading) {
                // Product Image
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(ColorTheme.secondaryText)
                    )
                
                // Product Info
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

#Preview {
    SearchView()
} 