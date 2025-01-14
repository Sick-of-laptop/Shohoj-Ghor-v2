import Foundation
import FirebaseFirestore
import FirebaseAuth

class NotificationViewModel: ObservableObject {
    @Published var notifications: [AppNotification] = []
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        setupNotificationListener()
    }
    
    func setupNotificationListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let notificationsRef = Firestore.firestore().collection("notifications")
        listenerRegistration = notificationsRef
            .whereFilter(Filter.orFilter([
                Filter.whereField("userId", isEqualTo: userId),
                Filter.whereField("isGlobal", isEqualTo: true)
            ]))
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                self?.notifications = documents.compactMap { document in
                    var notification = try? document.data(as: AppNotification.self)
                    notification?.firestoreId = document.documentID
                    return notification
                }
            }
    }
    
    func addNotification(type: NotificationType, message: String, isGlobal: Bool = false) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let notification = AppNotification(
            userId: userId,
            type: type,
            message: message,
            isGlobal: isGlobal,
            timestamp: Date()
        )
        
        do {
            try Firestore.firestore().collection("notifications")
                .document()
                .setData(from: notification)
        } catch {
            print("Error adding notification: \(error)")
        }
    }
    
    func markAsRead(_ notification: AppNotification) {
        guard let firestoreId = notification.firestoreId else { return }
        
        Firestore.firestore().collection("notifications")
            .document(firestoreId)
            .updateData(["isRead": true])
    }
    
    deinit {
        listenerRegistration?.remove()
    }
}

struct AppNotification: Identifiable, Codable {
    let id: String
    let userId: String
    let type: NotificationType
    let message: String
    let isGlobal: Bool
    let timestamp: Date
    var isRead: Bool
    var firestoreId: String?
    
    var identifier: String { id }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case type
        case message
        case isGlobal
        case timestamp
        case isRead
    }
    
    init(id: String = UUID().uuidString,
         userId: String,
         type: NotificationType,
         message: String,
         isGlobal: Bool,
         timestamp: Date,
         isRead: Bool = false,
         firestoreId: String? = nil) {
        self.id = id
        self.userId = userId
        self.type = type
        self.message = message
        self.isGlobal = isGlobal
        self.timestamp = timestamp
        self.isRead = isRead
        self.firestoreId = firestoreId
    }
}

enum NotificationType: String, Codable {
    case orderSuccess = "ORDER_SUCCESS"
    case newProduct = "NEW_PRODUCT"
    case promotion = "PROMOTION"
    case system = "SYSTEM"
} 