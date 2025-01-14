import Foundation

struct ProductSpecification: Codable, Identifiable {
    let id: String
    let category: String
    let name: String
    let specifications: Specifications
}

struct Specifications: Codable {
    let dimensions: Dimensions?
    let materials: [String]?
    let features: [String]?
    let weight_capacity: String?
    let color_options: [String]?
    let warranty: String
    let display: Display?
    let connectivity: [String]?
    let smart_features: [String]?
    let power: Power?
    let audio: Audio?
}

struct Dimensions: Codable {
    let length: String?
    let width: String?
    let height: String?
    let seat_height: String?
    let backrest_height: String?
}

struct Display: Codable {
    let size: String
    let resolution: String
    let panel_type: String
    let refresh_rate: String
}

struct Power: Codable {
    let voltage: String
    let consumption: String
}

struct Audio: Codable {
    let output: String
    let speakers: String
} 