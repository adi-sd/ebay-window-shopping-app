//
//  ApiManager.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/5/23.
//

import Foundation
import SwiftyJSON

enum APIError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case invalidData
}

func callAPI(endpoint: String, method: String, parameters: [String: Any]? = nil, body: String? = nil, completion: @escaping (Result<[String: Any], Error>) -> Void) {
    guard var urlComponents = URLComponents(string: endpoint) else {
        completion(.failure(APIError.invalidURL))
        return
    }
    
    // Append query parameters for GET requests
    if method == "GET", let parameters = parameters {
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
    }
    
    guard let url = urlComponents.url else {
        completion(.failure(APIError.invalidURL))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    
    // Set the request body for POST requests with parameters
    if method == "POST", let parameters = parameters {
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(.failure(error))
            return
        }
    }
    
    // Set the request body for POST requests with custom body
    if method == "POST", let body = body {
        request.httpBody = body.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            completion(.failure(APIError.requestFailed))
            return
        }
        
        guard let data = data else {
            completion(.failure(APIError.invalidData))
            return
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            completion(.success(jsonObject ?? [:]))
        } catch {
            completion(.failure(APIError.invalidResponse))
        }
    }
    
    task.resume()
}


// API Calls

func getCurrentLocationApiCall(completion: @escaping (Result<String, Error>) -> Void) {
    print("Calling getCurrentLocationApiCall")
    callAPI(endpoint: "https://ipinfo.io", method: "GET", parameters: ["token": "35b1e656f4785e"]) { result in
        switch result {
        case .success(let json):
            if let postalCode = json["postal"] as? String {
                //print("Postal Code: \(postalCode)")
                completion(.success(postalCode))
            } else {
                let error = NSError(domain: "AppDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Postal code not found in the response"])
                completion(.failure(error))
            }
            
        case .failure(let error):
            print("GET request failed. Error: \(error)")
            completion(.failure(error))
        }
    }
}

func getFindingServiceApiCall(filterObject: EbaySearchRequest, completion: @escaping (Result<[EbayResultItem], Error>) -> Void) {
    print("Calling getFindingServiceApiCall")
    
    if let filterObjectString = convertObjectToJSONString(filterObject) {
        print(filterObjectString)
        
        callAPI(endpoint: "https://adisd-csci571-hw03-ebay-app.uc.r.appspot.com/FindingService", method: "GET", parameters: ["filter_object_json" : filterObjectString as Any]) { result in
            switch result {
            case .success(let json):
                do {
                    guard let itemsJson = json["items"] as? [[String: Any]] else {
                        throw APIError.invalidResponse
                    }
                    let jsonData = try JSONSerialization.data(withJSONObject: itemsJson, options: [])
                    let decoder = JSONDecoder()
                    let items = try decoder.decode([EbayResultItem].self, from: jsonData)
                    print("GET request successful. Items: \(items)")
                    completion(.success(items))
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("GET request failed. Error: \(error)")
                completion(.failure(error))
            }
        }
    } else {
        print("Filter Object Couldn't be converted to String for API Call")
    }
    
}

func getAllWishListItemsApiCall(completion: @escaping (Result<[EbayWishlistItem], Error>) -> Void) {
    print("Calling getAllWishListItemsApiCall")
    callAPI(endpoint: "https://adisd-csci571-hw03-ebay-app.uc.r.appspot.com/wishlist/getAllItems", method: "GET") { result in
        switch result {
        case .success(let json):
            do {
                guard let itemsJson = json["items"] as? [[String: Any]] else {
                    throw APIError.invalidResponse
                }
                let jsonData = try JSONSerialization.data(withJSONObject: itemsJson, options: [])
                let decoder = JSONDecoder()
                let items = try decoder.decode([EbayWishlistItem].self, from: jsonData)
                print("GET request successful. Items: \(items)")
                completion(.success(items))
            } catch {
                print("Error decoding JSON: \(error)")
                completion(.failure(error))
            }
        case .failure(let error):
            print("GET request failed. Error: \(error)")
            completion(.failure(error))
        }
    }
}

// Add a Wishlist Item
func addWishlistItem(wishlistItem: EbayResultItem, completion: @escaping (Result<InsertionResponse, Error>) -> Void) {
    print("Calling addWishlistItem API...")
    do {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(wishlistItem)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            callAPI(endpoint: "https://adisd-csci571-hw03-ebay-app.uc.r.appspot.com/wishlist/addSingleItem", method: "POST", body: jsonString) { result in
                switch result {
                case .success(let json):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                        let decoder = JSONDecoder()
                        let newItem = try decoder.decode(InsertionResponse.self, from: jsonData)
                        print("POST request successful. Added Item: \(newItem)")
                        completion(.success(newItem))
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(.failure(error))
                    }
                case .failure(let error):
                    print("POST request failed. Error: \(error)")
                    completion(.failure(error))
                }
            }
        } else {
            print("Wishlist item couldn't be converted to JSON string.")
            completion(.failure(APIError.invalidData))
        }
    } catch {
        print("Error encoding wishlist item: \(error)")
        completion(.failure(error))
    }
}


// Delete a Wishlist Item
func deleteWishlistItem(itemId: String, completion: @escaping (Result<Void, Error>) -> Void) {
    print("Calling deleteWishlistItem API...")
    let endpoint = "https://adisd-csci571-hw03-ebay-app.uc.r.appspot.com/wishlist/deleteSingleItem?item_id=\(itemId)"
    callAPI(endpoint: endpoint, method: "DELETE") { result in
        switch result {
        case .success:
            print("DELETE request successful. Item deleted successfully.")
            completion(.success(()))
        case .failure(let error):
            print("DELETE request failed. Error: \(error)")
            completion(.failure(error))
        }
    }
}

// Find Single Item in WishList
func findSingleInWishList(itemId: String, completion: @escaping (Result<Void, Error>) -> Void) {
    print("Calling findSingleInWishList API...")
    let endpoint = "https://adisd-csci571-hw03-ebay-app.uc.r.appspot.com/wishlist/getSingleItem?item_id=\(itemId)"
    callAPI(endpoint: endpoint, method: "GET") { result in
        switch result {
        case .success:
            print("GET request successful. Item deleted successfully.")
            completion(.success(()))
        case .failure(let error):
            print("GET request failed. Error: \(error)")
            completion(.failure(error))
        }
    }
}

// Get Item Details from Ebay

//func getItemDetails(itemId: String, completion: @escaping (Result<EbayItemDetails, Error>) -> Void) {
//    print("Calling getItemDetails API...")
//    let endpoint = "https://adisd-csci571-hw03-ebay-app.uc.r.appspot.com/GetSingleItem?item_id=\(itemId)"
//    callAPI(endpoint: endpoint, method: "GET") { result in
//        switch result {
//        case .success(let responseData):
//            do {
//                print("GET request successful. Item details retrieved successfully.")
//                
//                if let ack = responseData["Ack"] as? String {
//                    if(ack) == "Success" {
//                        let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: [])
//                        let decoder = JSONDecoder()
//                        let item = try decoder.decode(EbayItemDetails.self, from: jsonData)
//                        completion(.success(item))
//                    } else {
//                        print("Error Response form the API \(responseData["Errors"]!)")
//                        throw APIError.requestFailed
//                    }
//                }
//            } catch {
//                print("Error decoding response: \(error)")
//                completion(.failure(error))
//            }
//        case .failure(let error):
//            print("GET request failed. Error: \(error)")
//            completion(.failure(error))
//        }
//    }
//}

func getItemDetails(itemId: String, completion: @escaping (Result<EbayItemDetails, Error>) -> Void) {
    print("Calling getItemDetails API...")
    
    let endpoint = "https://adisd-csci571-hw03-ebay-app.uc.r.appspot.com/GetSingleItem?item_id=\(itemId)"
    
    callAPI(endpoint: endpoint, method: "GET") { result in
        switch result {
        case .success(let responseData):
            do {
                print("GET request successful. Item details retrieved successfully.")
                
                let json = JSON(responseData)
                
                if let ack = json["Ack"].string, ack == "Success" {
                    let jsonData = try json.rawData()
                    let decoder = JSONDecoder()
                    let item = try decoder.decode(EbayItemDetails.self, from: jsonData)
                    completion(.success(item))
                } else {
                    print("Error Response form the API \(json["Errors"])")
                    throw APIError.requestFailed
                }
            } catch {
                print("Error decoding response: \(error)")
                completion(.failure(error))
            }
        case .failure(let error):
            print("GET request failed. Error: \(error)")
            completion(.failure(error))
        }
    }
}



