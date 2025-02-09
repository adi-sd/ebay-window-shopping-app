//
//  ebayResultItemStruct.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/6/23.
//

import Foundation

struct EbayResultItem: Identifiable, Codable {
    let id: String
    let itemId: String
    let itemTitle: String
    let itemImage: String
    let itemZipCode: String
    let itemPrice: String
    let itemShipping: String
    let itemCondition: String
    let itemUrlonEbay: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case itemId
        case itemTitle
        case itemImage
        case itemZipCode
        case itemPrice
        case itemShipping
        case itemCondition
        case itemUrlonEbay
    }
}

struct EbayWishlistItem: Identifiable, Codable {
    let id: String
    let itemId: String
    let itemTitle: String
    let itemImage: String
    let itemZipCode: String
    let itemPrice: String
    let itemShipping: String
    let itemCondition: String
    let itemUrlonEbay: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case itemId
        case itemTitle
        case itemImage
        case itemZipCode
        case itemPrice
        case itemShipping
        case itemCondition
        case itemUrlonEbay
    }
}

struct InsertionResponse: Codable {
    let acknowledged: Bool
    let insertedId: String
    
    private enum CodingKeys: String, CodingKey {
        case acknowledged
        case insertedId
    }
}

struct IntemDetailsResponse: Codable {
    
}


struct ErrorResponse: Codable {
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case message
    }
}


