//
//  File.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/5/23.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func fetchData(from endpoint: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    // Convert the data to a JSON object
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let json = json {
                        // Print the JSON response
                        print("Received JSON:", json)
                        completion(.success(json))
                    } else {
                        // If the data couldn't be converted to JSON, pass an error
                        completion(.failure(NetworkError.invalidResponse))
                    }
                } catch {
                    // Handle JSON serialization error
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}
