import Foundation
import UIKit

class ImgurUploader {
    private let clientID = "YOUR_IMGUR_CLIENT_ID" // Get this from imgur.com/api/
    private let baseURL = "https://api.imgur.com/3/image"
    
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        // Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // Create request
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        // Create form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Make request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let data = json["data"] as? [String: Any],
                  let link = data["link"] as? String else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            completion(.success(link))
        }.resume()
    }
} 