import Foundation

struct Product: Identifiable, Codable {
    let id = UUID()
    let name: String
    let price: Double
    let description: String
    let image: String
    let category: ProductCategory
    let isPopular: Bool
    let isNew: Bool
}

enum ProductCategory: String, CaseIterable, Codable {
    case furniture = "Furniture"
    case homeAppliances = "Home Appliances"
    case homeDecor = "Home Decor"
    case outdoor = "Outdoor"
    case storage = "Storage"
    case smartHome = "Smart Home"
}

extension Product {
    var asDictionary: [String: Any] {
        [
            "id": id.uuidString,
            "name": name,
            "price": price,
            "description": description,
            "image": image,
            "category": category.rawValue,
            "isPopular": isPopular,
            "isNew": isNew
        ]
    }
} 