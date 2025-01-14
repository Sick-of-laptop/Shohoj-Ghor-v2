import Foundation
import FirebaseFirestore
import FirebaseAuth

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var orderHistory: [Order] = []
    
    private let db = Firestore.firestore()
    private var cartListener: ListenerRegistration?
    private var orderListener: ListenerRegistration?
    
    init() {
        setupCartListener()
        setupOrderListener()
    }
    
    private func setupCartListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Remove existing listener
        cartListener?.remove()
        
        // Listen to user's cart document
        cartListener = db.collection("carts")
            .document(userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching cart: \(error.localizedDescription)")
                    return
                }
                
                // If document doesn't exist, create empty cart
                guard let document = snapshot, document.exists else {
                    self.cartItems = []
                    return
                }
                
                // Try to decode cart data
                if let data = try? document.data(as: Cart.self) {
                    self.cartItems = data.items
                }
            }
    }
    
    private func setupOrderListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Remove existing listener
        orderListener?.remove()
        
        // Listen to user's orders
        orderListener = db.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching orders: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.orderHistory = []
                    return
                }
                
                self.orderHistory = documents.compactMap { document -> Order? in
                    try? document.data(as: Order.self)
                }
            }
    }
    
    func addToCart(product: Product, quantity: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let cartRef = db.collection("carts").document(userId)
        
        if let existingIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            var updatedItems = cartItems
            updatedItems[existingIndex].quantity += quantity
            updateCart(items: updatedItems)
        } else {
            let newItem = CartItem(product: product, quantity: quantity)
            updateCart(items: cartItems + [newItem])
        }
    }
    
    private func updateCart(items: [CartItem]) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let cart = Cart(userId: userId, items: items)
        
        do {
            try db.collection("carts").document(userId).setData(from: cart) { [weak self] error in
                if let error = error {
                    print("Error updating cart: \(error.localizedDescription)")
                } else {
                    // Update local cart items
                    DispatchQueue.main.async {
                        self?.cartItems = items
                    }
                }
            }
        } catch {
            print("Error encoding cart: \(error.localizedDescription)")
        }
    }
    
    func updateQuantity(for item: CartItem, newQuantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            var updatedItems = cartItems
            updatedItems[index].quantity = max(1, newQuantity)
            updateCart(items: updatedItems)
        }
    }
    
    func removeFromCart(item: CartItem) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Remove item locally
        cartItems.removeAll { $0.id == item.id }
        
        // Update Firestore
        if cartItems.isEmpty {
            // If cart is empty, delete the cart document
            db.collection("carts").document(userId).delete { error in
                if let error = error {
                    print("Error deleting cart: \(error.localizedDescription)")
                }
            }
        } else {
            // Update cart with remaining items
            updateCart(items: cartItems)
        }
    }
    
    func clearCart() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        // Delete cart document
        db.collection("carts").document(userId).delete { [weak self] error in
            if let error = error {
                print("Error deleting cart: \(error.localizedDescription)")
            } else {
                // Clear local cart items
                DispatchQueue.main.async {
                    self?.cartItems.removeAll()
                }
            }
        }
    }
    
    // New method for creating orders
    func createOrder(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let newOrder = Order(
            userId: userId,
            items: cartItems,
            totalAmount: totalAmount,
            date: Date()
        )
        
        do {
            try db.collection("orders").addDocument(from: newOrder)
            
            // Add notification
            NotificationViewModel().addNotification(
                type: .orderSuccess,
                message: "Order placed successfully! Total: $\(String(format: "%.2f", totalAmount))"
            )
            
            clearCart()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    var totalAmount: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    deinit {
        cartListener?.remove()
        orderListener?.remove()
    }
}

// Firestore Models
struct Cart: Codable {
    let userId: String
    let items: [CartItem]
}

struct CartItem: Identifiable, Codable, Equatable {
    let id: UUID
    let product: Product
    var quantity: Int
    
    init(id: UUID = UUID(), product: Product, quantity: Int) {
        self.id = id
        self.product = product
        self.quantity = quantity
    }
    
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Order: Identifiable, Codable {
    let id: String
    let userId: String
    let items: [CartItem]
    let totalAmount: Double
    let date: Date
    
    init(id: String = UUID().uuidString, userId: String, items: [CartItem], totalAmount: Double, date: Date) {
        self.id = id
        self.userId = userId
        self.items = items
        self.totalAmount = totalAmount
        self.date = date
    }
} 