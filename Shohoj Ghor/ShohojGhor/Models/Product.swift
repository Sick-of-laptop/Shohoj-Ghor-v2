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
    case all = "All"
    case popular = "Popular"
    case forYou = "For You"
    case new = "New"
} 