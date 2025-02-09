//
//  SellerInfoView.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/7/23.
//

import SwiftUI

struct SellerInfoView: View {
    
    @State var itemDetails: EbayItemDetails?
    
    var body: some View {
        VStack {
            
            if let itemDetails = itemDetails {
                VStack(spacing: 5) {
                    Divider()
                    HStack{
                        Image(systemName: "house")
                        Text("Seller")
                    } .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    let storeName = itemDetails.Item.Storefront.StoreName
                    let storeUrl = itemDetails.Item.Storefront.StoreURL
                    HStack {
                        Text("Store Name")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("[\(storeName)](\(storeUrl))")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    let feedbackScore = itemDetails.Item.Seller.FeedbackScore
                    HStack {
                        Text("Feedback Score")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(String(feedbackScore))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    let popularity = itemDetails.Item.Seller.PositiveFeedbackPercent
                    HStack {
                        Text("Popularity")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(String(popularity))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                VStack(spacing: 5) {
                    Divider()
                    HStack{
                        Image(systemName: "sailboat")
                        Text("Shipping Info")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    //let shippingCost = shippingCost != nil ? String(shippingCost) : "FREE"
                    HStack {
                        Text("Shipping Cost")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("FREE")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    let globalShipping = itemDetails.Item.GlobalShipping == true ? "Yes" : "No"
                    HStack {
                        Text("Global Shipping")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(globalShipping)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    let handlingTime = itemDetails.Item.HandlingTime
                    HStack {
                        Text("Handling Time")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(String(handlingTime))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                VStack(spacing: 5) {
                    Divider()
                    HStack{
                        Image(systemName: "return")
                        Text("Return Policy")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    let returnsAccepted = itemDetails.Item.ReturnPolicy.ReturnsAccepted
                    HStack {
                        Text("Policy")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(returnsAccepted)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    let refundMode = itemDetails.Item.ReturnPolicy.Refund
                    HStack {
                        Text("Refund Mode")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(refundMode)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    let returnsWithin = itemDetails.Item.ReturnPolicy.ReturnsWithin
                    HStack {
                        Text("Refund Within")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(returnsWithin)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    let shippingCostPaidBy = itemDetails.Item.ReturnPolicy.ShippingCostPaidBy
                    HStack {
                        Text("Shipping Cost Paid By")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text(shippingCostPaidBy)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            
        }.padding()
    }
}

#Preview {
    SellerInfoView()
}
