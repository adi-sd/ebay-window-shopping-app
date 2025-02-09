//
//  ProductDetailsView.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/7/23.
//

import SwiftUI

struct ProductDetailsView: View {
    
    @State var itemId: String
    @State var itemDetails: EbayItemDetails?
    
    @State private var isLoading : Bool = false;
    
    var body: some View {
        
        NavigationView {
            TabView {
                if(!isLoading) {
                    VStack {
                        if let itemDetails = self.itemDetails {
                            ProductInfoView(itemDetails: itemDetails)
                        } else {
                            Text("Item info for id - \(itemId)")
                        }
                    }
                    .tabItem {
                        Image(systemName: "info.circle.fill")
                        Text("Info")
                    }

                    // Tab 2
                    VStack {
                        if let itemDetails = self.itemDetails {
                            SellerInfoView(itemDetails: itemDetails)
                        } else {
                            Text("Seller/Shipping for id - \(itemId)")
                        }
                    }
                    .tabItem {
                        Image(systemName: "shippingbox.fill")
                        Text("Shipping")
                    }

                    // Tab 3
                    Text("Photos for id - \(itemId)")
                    .tabItem {
                        Image(systemName: "photo.stack.fill")
                        Text("Photos")
                    }
                    
                    // Tab 4
                    Text("Similar Items for id - \(itemId)")
                    .tabItem {
                        Image(systemName: "list.bullet.indent")
                        Text("Similar")
                    }
                } else {
                    HStack {
                        Spacer()
                        ProgressView("Please Wait...")
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                }
            }
            .onAppear() {
                getSingleItemDetails()
            }
            .navigationBarItems(trailing: NavigationLink(destination: WishlistView()) {
                Image("fb")
                    .resizable()
                    .frame(width: 25, height: 25)
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.red)
                
            })
            .background(Color(.systemBackground))
        }
    }
    
    func getSingleItemDetails() {
        self.isLoading = true;
        getItemDetails(itemId: itemId) { result in
            switch result {
            case .success(let itemDetails):
                print("Item Details: \(itemDetails)")
                self.itemDetails = itemDetails
                self.isLoading = false
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
}

#Preview {
    ProductDetailsView(itemId: "225494721576")
}
