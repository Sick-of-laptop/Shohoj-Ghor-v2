import SwiftUI

struct HomeView: View {
    @StateObject private var productViewModel = ProductViewModel()
    @State private var selectedCategory: ProductCategory = .all
    @State private var isAnimating = false
    @Binding var showSidebar: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(ProductCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    title: category.rawValue,
                                    isSelected: selectedCategory == category
                                ) {
                                    withAnimation {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Featured Items with sliding
                    FeaturedItemsView(products: productViewModel.filteredProducts(for: selectedCategory))
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 50)
                    
                    // Popular Items Grid
                    PopularItemsGridView(products: productViewModel.filteredProducts(for: selectedCategory))
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : 30)
                }
            }
            .navigationTitle("Shohoj Ghor")
            .navigationBarItems(
                trailing: Button(action: {
                    withAnimation {
                        showSidebar.toggle()
                    }
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(ColorTheme.text)
                        .font(.title3)
                }
            )
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? ColorTheme.navigation : ColorTheme.primary)
                )
                .foregroundColor(isSelected ? .white : ColorTheme.text)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

// Preview provider for HomeView
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showSidebar: .constant(false))
    }
} 