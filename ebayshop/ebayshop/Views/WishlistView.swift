//
//  WishlistView.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/5/23.
//

import SwiftUI

struct WishlistView: View {
    
    @State private var wishlistProducts: [EbayWishlistItem] = []
    @State private var wishlistTotal: Double = 0
    @State private var isLoading: Bool = false;
    
    var body: some View {
        
        VStack{
            if(isLoading) {
                Text("Loading...")
            } else {
                if( wishlistProducts.count > 0 ) {
                    Form {
                        HStack {
                            Text("Wishlist total(\(wishlistProducts.count)) items:")
                            Spacer()
                            Text("$\(String(wishlistTotal))")
                        }
                        ForEach(wishlistProducts) { item in
                            HStack {
                                AsyncImage(url: URL(string: item.itemImage)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(5)
                                } placeholder: {

                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(5)
                                }

                                VStack(alignment: .leading, spacing: 5) {
                                    Text(item.itemTitle)
                                        .lineLimit(1)
                                        .font(.headline)

                                    Text("$\(item.itemPrice)")
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.blue)

                                    
                                    if( item.itemShipping == "Free Shipping" ) {
                                        Text("FREE SHIPPING").foregroundColor(.gray)
                                    } else {
                                        Text("\(item.itemShipping)")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    HStack {
                                        Text("\(item.itemZipCode)")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("\(mapCondition(conditionID: item.itemCondition))")
                                            .foregroundColor(.gray)

                                    }
                                }
                            }
                        }
                    }
                } else {
                    HStack{
                        Text("No items in wishlist")
                    }
                }
            }
        }
        .navigationBarTitle("Favourites", displayMode: .automatic)
        .onAppear() {
            isLoading = true;
            getWishListItems()
        }
    }
    
    
    func getWishListItems() {
        getAllWishListItemsApiCall { result in
            switch result {
            case .success(let items):
                print("Wishlist items: \(items)")
                wishlistProducts = items
                wishlistTotal = calculateTotalPrice(items: items)
            case .failure(let error):
                print("Error getting wishlist items: \(error)")
            }
            isLoading = false
        }
    }
    
    func calculateTotalPrice(items: [EbayWishlistItem]) -> Double {
        var totalPrice: Double = 0.0
        for item in items {
            var priceString = item.itemPrice
            if priceString.hasPrefix("$") {
                priceString.removeFirst()
            }
            if let price = Double(priceString) {
                totalPrice += price
            }
        }
        totalPrice = round(totalPrice * 100) / 100
        print("Total Price - \(totalPrice)")
        return totalPrice
    }
    
}

#Preview {
    WishlistView()
}
