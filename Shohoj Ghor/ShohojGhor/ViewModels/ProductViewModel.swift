import Foundation

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = [
        // Furniture
        Product(name: "Modern Sofa", price: 599.0, description: "Elegant and comfortable sofa", image: "sofa", category: .furniture, isPopular: true, isNew: false),
        Product(name: "Dining Chair", price: 199.0, description: "Comfortable dining chair", image: "chair", category: .furniture, isPopular: false, isNew: false),
        Product(name: "Coffee Table", price: 299.0, description: "Stylish coffee table", image: "table", category: .furniture, isPopular: true, isNew: false),
        
        // Home Appliances
        Product(name: "Smart Refrigerator", price: 1299.0, description: "Modern refrigerator with smart features", image: "fridge", category: .homeAppliances, isPopular: true, isNew: true),
        Product(name: "Washing Machine", price: 699.0, description: "Efficient washing machine", image: "washer", category: .homeAppliances, isPopular: false, isNew: false),
        
        // Home Decor
        Product(name: "Table Lamp", price: 79.0, description: "Modern table lamp", image: "lamp", category: .homeDecor, isPopular: false, isNew: true),
        Product(name: "Wall Art", price: 149.0, description: "Beautiful wall decoration", image: "art", category: .homeDecor, isPopular: true, isNew: false),
        
        // Outdoor
        Product(name: "Garden Chair", price: 129.0, description: "Comfortable outdoor chair", image: "garden-chair", category: .outdoor, isPopular: false, isNew: true),
        Product(name: "Patio Table", price: 249.0, description: "Elegant patio table", image: "patio-table", category: .outdoor, isPopular: true, isNew: false),
        
        // Storage
        Product(name: "Bookshelf", price: 399.0, description: "Spacious bookshelf", image: "shelf", category: .storage, isPopular: false, isNew: false),
        Product(name: "Wardrobe", price: 899.0, description: "Large wardrobe", image: "wardrobe", category: .storage, isPopular: true, isNew: true),
        
        // Smart Home
        Product(name: "Smart Light Bulb", price: 49.0, description: "WiFi-enabled smart bulb", image: "bulb", category: .smartHome, isPopular: true, isNew: true),
        Product(name: "Security Camera", price: 199.0, description: "Smart security camera", image: "camera", category: .smartHome, isPopular: false, isNew: true)
    ]
    
    func filteredProducts(for category: ProductCategory?) -> [Product] {
        guard let category = category else {
            return products // Return all products if no category is selected
        }
        return products.filter { $0.category == category }
    }
    
    // Add a function to get popular products
    func popularProducts() -> [Product] {
        return products.filter { $0.isPopular }
    }
    
    // Add a function to get new products
    func newProducts() -> [Product] {
        return products.filter { $0.isNew }
    }
} 