import Foundation
import SwiftUI

@MainActor
class SpecificationViewModel: ObservableObject {
    @Published var products: [ProductSpecification] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiURL = "https://mocki.io/v1/1e460de5-a098-4070-a33b-f5f7236c31e3"
    
    func fetchProducts() {
        isLoading = true
        error = nil
        
        Task {
            do {
                guard let url = URL(string: apiURL) else {
                    error = "Invalid URL"
                    isLoading = false
                    return
                }
                
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(ProductSpecificationsResponse.self, from: data)
                
                if response.products.isEmpty {
                    error = "No products available"
                } else {
                    products = response.products
                }
                
                isLoading = false
            } catch {
                self.error = "Error loading products: \(error.localizedDescription)"
                isLoading = false
            }
        }
    }
}

struct ProductSpecificationsResponse: Codable {
    let products: [ProductSpecification]
} 
