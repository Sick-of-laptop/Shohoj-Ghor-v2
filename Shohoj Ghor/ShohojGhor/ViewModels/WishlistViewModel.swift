import Foundation
import FirebaseFirestore
import FirebaseAuth

class WishlistViewModel: ObservableObject {
    @Published var wishlistItems: [Product] = []
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        setupWishlistListener()
    }
    
    func setupWishlistListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let wishlistRef = Firestore.firestore().collection("wishlists").document(userId)
        listenerRegistration = wishlistRef.addSnapshotListener { [weak self] snapshot, error in
            guard let document = snapshot, document.exists,
                  let data = document.data(),
                  let products = data["products"] as? [[String: Any]] else { return }
            
            self?.wishlistItems = products.compactMap { productData in
                guard let name = productData["name"] as? String,
                      let price = productData["price"] as? Double,
                      let description = productData["description"] as? String,
                      let image = productData["image"] as? String,
                      let categoryString = productData["category"] as? String,
                      let category = ProductCategory(rawValue: categoryString),
                      let isPopular = productData["isPopular"] as? Bool,
                      let isNew = productData["isNew"] as? Bool else {
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
    
    func addToWishlist(_ product: Product) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let wishlistRef = Firestore.firestore().collection("wishlists").document(userId)
        
        wishlistRef.getDocument { snapshot, error in
            if let document = snapshot, document.exists {
                // Update existing wishlist
                wishlistRef.updateData([
                    "products": FieldValue.arrayUnion([product.asDictionary])
                ])
            } else {
                // Create new wishlist
                wishlistRef.setData([
                    "products": [product.asDictionary]
                ])
            }
        }
    }
    
    func removeFromWishlist(_ product: Product) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let wishlistRef = Firestore.firestore().collection("wishlists").document(userId)
        wishlistRef.updateData([
            "products": FieldValue.arrayRemove([product.asDictionary])
        ])
    }
    
    func isInWishlist(_ product: Product) -> Bool {
        wishlistItems.contains { $0.id == product.id }
    }
    
    deinit {
        listenerRegistration?.remove()
    }
} 