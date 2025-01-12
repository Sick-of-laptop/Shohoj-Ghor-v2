import Foundation

struct User: Identifiable {
    let id: String
    let fullName: String
    let email: String
    let phone: String
    
    init(data: [String: Any]) {
        self.id = data["uid"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.phone = data["phone"] as? String ?? ""
    }
} 