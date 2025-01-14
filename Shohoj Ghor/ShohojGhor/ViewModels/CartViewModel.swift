import Foundation

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = [] {
        didSet {
            saveCart()
        }
    }
    
    @Published var orderHistory: [Order] = [] {
        didSet {
            saveOrders()
        }
    }
    
    private let notificationViewModel = NotificationViewModel()
    
    init() {
        loadCart()
        loadOrders()
    }
    
    func addToCart(product: Product, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            // Product already in cart, update quantity
            cartItems[index].quantity += quantity
        } else {
            // Add new product to cart
            let newItem = CartItem(product: product, quantity: quantity)
            cartItems.append(newItem)
        }
        
        // Force a UI update
        objectWillChange.send()
    }
    
    func updateQuantity(for item: CartItem, newQuantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity = max(1, newQuantity)
            // Force a UI update
            objectWillChange.send()
        }
    }
    
    func removeFromCart(item: CartItem) {
        cartItems.removeAll(where: { $0.id == item.id })
        // Force a UI update
        objectWillChange.send()
    }
    
    var totalAmount: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    func clearCart() {
        // Add current cart items to order history
        let newOrder = Order(
            items: cartItems,
            totalAmount: totalAmount,
            date: Date()
        )
        orderHistory.append(newOrder)
        
        // Add notification with properly formatted amount and item count
        let itemCount = cartItems.reduce(0) { $0 + $1.quantity }
        let formattedAmount = String(format: "%.2f", totalAmount)
        let itemText = itemCount == 1 ? "item" : "items"
        
        notificationViewModel.addNotification(
            type: .orderSuccess,
            message: "Your order of \(itemCount) \(itemText) for $\(formattedAmount) has been confirmed! Thank you for shopping with us."
        )
        
        // Clear cart
        cartItems.removeAll()
    }
    
    private func saveCart() {
        if let encoded = try? JSONEncoder().encode(cartItems) {
            UserDefaults.standard.set(encoded, forKey: "cart_items")
        }
    }
    
    private func loadCart() {
        if let data = UserDefaults.standard.data(forKey: "cart_items"),
           let decoded = try? JSONDecoder().decode([CartItem].self, from: data) {
            cartItems = decoded
        }
    }
    
    private func saveOrders() {
        if let encoded = try? JSONEncoder().encode(orderHistory) {
            UserDefaults.standard.set(encoded, forKey: "order_history")
        }
    }
    
    private func loadOrders() {
        if let data = UserDefaults.standard.data(forKey: "order_history"),
           let decoded = try? JSONDecoder().decode([Order].self, from: data) {
            orderHistory = decoded
        }
    }
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
    let id = UUID()
    let items: [CartItem]
    let totalAmount: Double
    let date: Date
} 