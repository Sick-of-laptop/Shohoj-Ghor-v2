import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class MyOrderViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        setupOrderListener()
    }
    
    private func setupOrderListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        error = nil
        
        // Remove existing listener if any
        listener?.remove()
        
        // Simple query to fetch user's orders
        listener = db.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.error = error.localizedDescription
                    print("Error fetching orders: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.orders = []
                    return
                }
                
                self.orders = documents.compactMap { document -> Order? in
                    try? document.data(as: Order.self)
                }
                
                // Sort locally by date
                self.orders.sort { $0.date > $1.date }
                
                print("Fetched \(self.orders.count) orders for user \(userId)")
            }
    }
    
    func refreshOrders() {
        setupOrderListener()
    }
    
    func getOrderStatus(_ order: Order) -> (String, Color) {
        let hoursSinceOrder = Calendar.current.dateComponents([.hour], from: order.date, to: Date()).hour ?? 0
        
        switch hoursSinceOrder {
        case 0...24:
            return ("Processing", .orange)
        case 25...48:
            return ("Shipped", .blue)
        default:
            return ("Delivered", .green)
        }
    }
    
    deinit {
        listener?.remove()
    }
} 