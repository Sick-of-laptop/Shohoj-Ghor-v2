import Foundation

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = [
        Product(name: "Modern Sofa", price: 599.0, description: "Elegant and comfortable sofa", image: "sofa", category: .popular, isPopular: true, isNew: false),
        Product(name: "Table Lamp", price: 79.0, description: "Modern table lamp", image: "lamp", category: .new, isPopular: false, isNew: true),
        Product(name: "Dining Chair", price: 199.0, description: "Comfortable dining chair", image: "chair", category: .forYou, isPopular: false, isNew: false),
        Product(name: "Coffee Table", price: 299.0, description: "Stylish coffee table", image: "table", category: .popular, isPopular: true, isNew: false),
        Product(name: "Floor Lamp", price: 149.0, description: "Modern floor lamp", image: "lamp", category: .new, isPopular: false, isNew: true),
        Product(name: "Bookshelf", price: 399.0, description: "Spacious bookshelf", image: "shelf", category: .forYou, isPopular: false, isNew: false),
        Product(name: "Bed Frame", price: 899.0, description: "Queen size bed frame", image: "bed", category: .popular, isPopular: true, isNew: false),
        Product(name: "Nightstand", price: 129.0, description: "Matching nightstand", image: "nightstand", category: .new, isPopular: false, isNew: true),
        Product(name: "Desk", price: 349.0, description: "Work from home desk", image: "desk", category: .forYou, isPopular: false, isNew: false)
    ]
    
    func filteredProducts(for category: ProductCategory) -> [Product] {
        switch category {
        case .all:
            return products
        case .popular:
            return products.filter { $0.category == .popular }
        case .new:
            return products.filter { $0.category == .new }
        case .forYou:
            return products.filter { $0.category == .forYou }
        }
    }
} 