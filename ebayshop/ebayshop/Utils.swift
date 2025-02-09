//
//  Utils.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/5/23.
//

import Foundation
import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .font(.system(size: 20, weight: .regular, design: .default))
            configuration.label
        }
        .onTapGesture { configuration.isOn.toggle() }
    }
}

struct ProductCategory: Identifiable {
    var id: Int
    var name: String
}


func convertObjectToJSONString<T: Encodable>(_ object: T) -> String? {
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(object)
        return String(data: jsonData, encoding: .utf8)
    } catch {
        print("Error encoding the object to JSON: \(error)")
        return nil
    }
}

func mapCondition(conditionID: String) -> String {
    switch conditionID {
    case "1000":
        return "NEW"
    case "2000", "2500":
        return "REFURBISHED"
    case "3000", "4000", "5000", "6000":
        return "USED"
    default:
        return "NA"
    }
}

func indexOfItem(withItemId itemId: String, in array: [EbayResultItem]) -> Int? {
    for (index, item) in array.enumerated() {
        if item.itemId == itemId {
            return index
        }
    }
    return nil
}

func isNumeric(_ input: String) -> Bool {
    let numericCharacterSet = CharacterSet.decimalDigits
    return input.rangeOfCharacter(from: numericCharacterSet.inverted) == nil
}
