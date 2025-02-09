import Foundation

struct EbayItemDetails: Codable {
    let Timestamp: String
    let Ack: String
    let Build: String
    let Version: String
    let Item: EbayItem
}

struct EbayItem: Codable {
    let BestOfferEnabled: Bool
    let Description: String
    let ItemID: String
    let EndTime: String
    let StartTime: String
    let ViewItemURLForNaturalSearch: String
    let ListingType: String
    let Location: String
    let PaymentMethods: [String]
    let PictureURL: [String]
    let PostalCode: String
    let PrimaryCategoryID: String
    let PrimaryCategoryName: String
    let Quantity: Int
    let Seller: EbaySeller
    let BidCount: Int
    let ConvertedCurrentPrice: EbayPrice
    let CurrentPrice: EbayPrice
    let ListingStatus: String
    let QuantitySold: Int
    let ShipToLocations: [String]
    let Site: String
    let TimeLeft: String
    let Title: String
    let ItemSpecifics: EbayItemSpecifics
    let Subtitle: String
    let PrimaryCategoryIDPath: String
    let Storefront: EbayStorefront
    let Country: String
    let ReturnPolicy: EbayReturnPolicy
    let AutoPay: Bool
    let PaymentAllowedSite: [String]
    let IntegratedMerchantCreditCardEnabled: Bool
    let HandlingTime: Int
    let ConditionID: Int
    let ConditionDisplayName: String
    let QuantityAvailableHint: String
    let QuantityThreshold: Int
    let ExcludeShipToLocation: [String]
    let TopRatedListing: Bool
    let GlobalShipping: Bool
    let QuantitySoldByPickupInStore: Int
    let NewBestOffer: Bool
}

struct EbaySeller: Codable {
    let UserID: String
    let FeedbackRatingStar: String
    let FeedbackScore: Int
    let PositiveFeedbackPercent: Double
    let TopRatedSeller: Bool?
}

struct EbayPrice: Codable {
    let Value: Double
    let CurrencyID: String
}

struct EbayItemSpecifics: Codable {
    let NameValueList: [EbayNameValue]
}

struct EbayNameValue: Codable {
    let Name: String
    let Value: [String]
}

struct EbayStorefront: Codable {
    let StoreURL: String
    let StoreName: String
}

struct EbayReturnPolicy: Codable {
    let Refund: String
    let ReturnsWithin: String
    let ReturnsAccepted: String
    let ShippingCostPaidBy: String
    let InternationalRefund: String
    let InternationalReturnsWithin: String
    let InternationalReturnsAccepted: String
    let InternationalShippingCostPaidBy: String
}
