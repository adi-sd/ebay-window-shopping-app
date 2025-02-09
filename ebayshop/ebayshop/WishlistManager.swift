//
//  WishlistManager.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/7/23.
//

import Foundation

class WishlistManger {
    
    func addItemToWishlist(item: EbayResultItem, index: Int) -> Bool {
        var itemAddedToWishList = false;
        addWishlistItem(wishlistItem: item) { result in
            switch result {
            case .success(let addedItem):
                print("Successfully added wishlist item: \(addedItem)")
                itemAddedToWishList = true
            case .failure(let error):
                print("Failed to add wishlist item. Error: \(error)")
                itemAddedToWishList = false
            }
        }
        return itemAddedToWishList;
    }

    func removeItemFromWishlist(item: EbayResultItem, index: Int) -> Bool {
        var itemRemovedFromWishList = false;
        deleteWishlistItem(itemId: item.itemId) { result in
            switch result {
            case .success:
                print("Item deleted successfully.")
                itemRemovedFromWishList = true
            case .failure(let error):
                print("Error deleting item: \(error)")
                itemRemovedFromWishList = false
            }
        }
        return itemRemovedFromWishList
    }
    
}
