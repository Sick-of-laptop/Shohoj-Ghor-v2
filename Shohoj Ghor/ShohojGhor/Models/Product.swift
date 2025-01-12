import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let description: String
    let image: String
    let category: ProductCategory
    let isPopular: Bool
    let isNew: Bool
}

enum ProductCategory: String, CaseIterable {
    case furniture = "Furniture"
    case homeAppliances = "Home Appliances"
    case homeDecor = "Home Decor"
    case outdoor = "Outdoor"
    case storage = "Storage"
    case smartHome = "Smart Home"
} 