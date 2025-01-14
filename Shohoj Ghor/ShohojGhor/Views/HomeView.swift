import SwiftUI

struct HomeView: View {
    @StateObject private var productViewModel = ProductViewModel()
    @State private var selectedCategory: ProductCategory = .furniture
    @State private var isAnimating = false
    @Binding var showSidebar: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                if productViewModel.products.isEmpty {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.top, 100)
                        
                        Text("Loading products...")
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                } else {
                    VStack(spacing: 20) {
                        // Modern Categories View
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(ProductCategory.allCases, id: \.self) { category in
                                    ModernCategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category,
                                        action: {
                                            withAnimation {
                                                selectedCategory = category
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                        
                        // Featured Items with sliding
                        FeaturedItemsView(products: productViewModel.popularProducts())
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : 50)
                        
                        // Products Grid for selected category
                        PopularItemsGridView(products: productViewModel.filteredProducts(for: selectedCategory))
                            .opacity(isAnimating ? 1 : 0)
                            .offset(y: isAnimating ? 0 : 30)
                    }
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

struct ModernCategoryButton: View {
    let category: ProductCategory
    let isSelected: Bool
    let action: () -> Void
    
    // Category-specific icons
    private var iconName: String {
        switch category {
        case .furniture:
            return "sofa.fill"
        case .homeAppliances:
            return "tv.fill"
        case .homeDecor:
            return "lamp.table.fill"
        case .outdoor:
            return "leaf.fill"
        case .storage:
            return "archivebox.fill"
        case .smartHome:
            return "homekit"
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Icon
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : ColorTheme.navigation)
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(isSelected ? ColorTheme.navigation : Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                
                // Category Name
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? ColorTheme.navigation : ColorTheme.secondaryText)
                    .lineLimit(1)
                    .fixedSize()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview provider for HomeView
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showSidebar: .constant(false))
    }
} 