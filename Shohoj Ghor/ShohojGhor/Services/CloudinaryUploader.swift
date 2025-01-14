import Foundation
import UIKit

class CloudinaryUploader {
    private let cloudName = "dpdcsiixj"  // Find this in your dashboard main page
    private let uploadPreset = "shohoj_preset"  // The name you gave to your upload preset
    private let baseURL: String
    
    init() {
        self.baseURL = "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload"
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        // Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // Create request
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        
        // Create form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add upload preset
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(uploadPreset)".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Make request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let secureUrl = json["secure_url"] as? String else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            completion(.success(secureUrl))
        }.resume()
    }
} 