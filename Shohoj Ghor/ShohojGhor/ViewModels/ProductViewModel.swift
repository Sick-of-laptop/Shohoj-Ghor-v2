import Foundation
import FirebaseDatabase

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    private let ref = Database.database(url: "https://shohoj-ghor-default-rtdb.firebaseio.com/").reference()
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        ref.child("products").observe(.value) { [weak self] snapshot in
            guard let self = self,
                  let value = snapshot.value as? [String: [String: Any]] else { return }
            
            self.products = value.compactMap { dict in
                guard 
                    let productDict = dict.value as? [String: Any],
                    let name = productDict["name"] as? String,
                    let price = productDict["price"] as? Double,
                    let description = productDict["description"] as? String,
                    let image = productDict["image"] as? String,
                    let categoryString = productDict["category"] as? String,
                    let category = ProductCategory(rawValue: categoryString),
                    let isPopular = productDict["isPopular"] as? Bool,
                    let isNew = productDict["isNew"] as? Bool
                else { 
                    return nil 
                }
                
                return Product(
                    name: name,
                    price: price,
                    description: description,
                    image: image,
                    category: category,
                    isPopular: isPopular,
                    isNew: isNew
                )
            }
        }
    }
    
    func filteredProducts(for category: ProductCategory?) -> [Product] {
        guard let category = category else {
            return products
        }
        return products.filter { $0.category == category }
    }
    
    func popularProducts() -> [Product] {
        return products.filter { $0.isPopular }
    }
    
    func newProducts() -> [Product] {
        return products.filter { $0.isNew }
    }
} 