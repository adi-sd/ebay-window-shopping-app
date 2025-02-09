//
//  filterObjectStruct.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/4/23.
//

import Foundation

struct EbaySearchRequest: Encodable {
    var keywords: String
    var paginationInput: PaginationInput
    var categoryId: Int?
    var buyerPostalCode: String
    var itemFilter: [ItemFilter]
    var outputSelector: [String]
}

struct PaginationInput: Encodable {
    var entriesPerPage: Int
}

struct ItemFilter: Encodable {
    var name: String
    var value: ItemFilterValue
}

enum ItemFilterValue: Encodable {
    case string(String)
    case stringArr([String])
    case int(Int)
    case double(Double)
    case bool(Bool)

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .stringArr(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .bool(let value):
            try container.encode(value)
        }
    }
}

extension EbaySearchRequest {
    
    // Constants
    static let defaultEntriesPerPage = 50
    static let defaultOutputSelector = ["SellerInfo", "StoreInfo"]
    
    // Constant item filters
    static let constantItemFilters: [ItemFilter] = [
        ItemFilter(name: "HideDuplicateItems", value: .bool(true)),
        ItemFilter(name: "Currency", value: .string("USD"))
    ]
    
    static func defaultRequest(keywords: String, categoryId: Int, buyerPostalCode: String, maxDistance: Int, freeShipping: Bool, localPickup: Bool, newCondition: Bool, usedCondition: Bool, unspecifiedCondition: Bool) -> EbaySearchRequest {
        
        var currentItemFilter = constantItemFilters;
        
        currentItemFilter.append(ItemFilter(name : "MaxDistance", value: .int(maxDistance)))
                                 
        if (freeShipping) {
            currentItemFilter.append(ItemFilter(name : "FreeShippingOnly", value: .bool(true)))
        }
        
        if (localPickup) {
            currentItemFilter.append(ItemFilter(name : "LocalPickupOnly", value: .bool(true)))
        }
        
        var condtions : [String] = [];
        
        if(newCondition) {
            condtions.append("New")
        }
        
        if(usedCondition) {
            condtions.append("Used")
        }
        
        if(unspecifiedCondition) {
            condtions.append("Unspecified")
        }
        
        if(condtions.count > 0) {
            currentItemFilter.append(ItemFilter(name: "Condition", value: .stringArr(condtions)))
        }
                                    
        if( categoryId != 0 ) {
            return EbaySearchRequest(
                keywords: keywords,
                paginationInput: PaginationInput(entriesPerPage: defaultEntriesPerPage),
                categoryId: categoryId,
                buyerPostalCode: buyerPostalCode,
                itemFilter: currentItemFilter,
                outputSelector: defaultOutputSelector
            )
        } else {
            return EbaySearchRequest(
                keywords: keywords,
                paginationInput: PaginationInput(entriesPerPage: defaultEntriesPerPage),
                buyerPostalCode: buyerPostalCode,
                itemFilter: currentItemFilter,
                outputSelector: defaultOutputSelector
            )
        }
    }
}

func generateJSONString(request: EbaySearchRequest) -> String? {
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(request)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
    } catch {
        print("Error encoding to JSON: \(error)")
    }
    return nil
}
