import SwiftUI

struct SpecificationFinderView: View {
    @StateObject private var viewModel = SpecificationViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProduct: ProductSpecification?
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.background
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error")
                            .font(.headline)
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(ColorTheme.secondaryText)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else if viewModel.products.isEmpty {
                    Text("No specifications available")
                        .foregroundColor(ColorTheme.secondaryText)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.products) { product in
                                ProductSpecCard(product: product)
                                    .onTapGesture {
                                        selectedProduct = product
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Specification Finder")
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
        }
        .sheet(item: $selectedProduct) { product in
            SpecificationDetailView(product: product)
        }
        .onAppear {
            viewModel.fetchProducts()
        }
    }
}

struct ProductSpecCard: View {
    let product: ProductSpecification
    
    // Function to get appropriate icon for electronics products
    private func getProductIcon() -> String {
        switch product.name.lowercased() {
        case let name where name.contains("tv"):
            return "tv.fill"
        case let name where name.contains("refrigerator"):
            return "thermometer.snowflake"
        case let name where name.contains("ac"):
            return "air.conditioner.horizontal.fill"
        case let name where name.contains("washing"):
            return "washer.fill"
        case let name where name.contains("microwave"):
            return "microwave.fill"
        default:
            return "bolt.fill" // Default electronics icon
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Category Icon with electronics-specific icons
            Image(systemName: getProductIcon())
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(ColorTheme.navigation)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(ColorTheme.text)
                
                Text("Electronics")
                    .font(.subheadline)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
} 