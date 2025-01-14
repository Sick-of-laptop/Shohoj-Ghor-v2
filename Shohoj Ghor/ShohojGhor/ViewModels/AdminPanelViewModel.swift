import FirebaseDatabase
import Foundation

class AdminPanelViewModel: ObservableObject {
    @Published var products: [Product] = []
    private let ref = Database.database(url: "https://shohoj-ghor-default-rtdb.firebaseio.com/").reference()
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        ref.child("products").observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            
            self.products = value.compactMap { dict in
                guard 
                    let productDict = dict.value as? [String : Any],
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
    
    func addProduct(_ product: Product) {
        let productDict: [String: Any] = [
            "name": product.name,
            "price": product.price,
            "description": product.description,
            "image": product.image,
            "category": product.category.rawValue,
            "isPopular": product.isPopular,
            "isNew": product.isNew
        ]
        
        ref.child("products").childByAutoId().setValue(productDict)
        
        // Add global notification
        NotificationViewModel().addNotification(
            type: .newProduct,
            message: "New product added: \(product.name)",
            isGlobal: true
        )
    }
    
    func deleteProduct(_ product: Product) {
        // Find the product key first
        ref.child("products").queryOrdered(byChild: "name").queryEqual(toValue: product.name)
            .observeSingleEvent(of: .value) { snapshot in
                if let first = snapshot.children.allObjects.first as? DataSnapshot {
                    self.ref.child("products").child(first.key).removeValue()
                }
            }
    }
} 
