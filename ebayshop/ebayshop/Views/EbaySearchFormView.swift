//
//  EbaySearchFormView.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/5/23.
//


import SwiftUI

class SearchFormViewModel: ObservableObject {
    @Published var keywords: String = ""
    @Published var category: Int = 0
    var categoryOptions = [
        ProductCategory(id: 0, name: "All"),
        ProductCategory(id: 550, name: "Art"),
        ProductCategory(id: 2984, name: "Baby"),
        ProductCategory(id: 267, name: "Books"),
        ProductCategory(id: 11450, name: "Clothing, Shoes & Accessories"),
        ProductCategory(id: 58058, name: "Computer/Tablets & Networking"),
        ProductCategory(id: 26395, name: "Health & Beauty"),
        ProductCategory(id: 11233, name: "Music"),
        ProductCategory(id: 1249, name: "Video Games & Consoles")
    ]
    
    @Published var localPickup: Bool = false
    @Published var freeShipping: Bool = false
    @Published var newCondition: Bool = false
    @Published var usedCondition: Bool = false
    @Published var unspecifiedCondition: Bool = false
    @Published var distance: Int = 10
    @Published var customLocation: Bool = false
    @Published var buyerZipCode: String = ""
    
    @Published var showResults = false
    @Published var showingEmptyKeywordAlert = false
}

struct EbaySearchFormView: View {
    @StateObject private var viewModel = SearchFormViewModel()
    @State private var resultListProducts: [EbayResultItem] = []
    @State private var favouriteState: [Bool] = []
    @State private var isResultLoading: Bool = false
    
    @State private var selectedItemIndex: Bool = false;
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        HStack {
                            Text("Keyword:")
                            TextField("Required", text: $viewModel.keywords)
                        }
                        
                        Picker("Category", selection: $viewModel.category) {
                            ForEach(viewModel.categoryOptions) { option in
                                Text(option.name)
                                    .foregroundColor(.blue)
                                    .tag(option.id)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Condition")
                            HStack {
                                Spacer()
                                Toggle(isOn: $viewModel.usedCondition) {
                                    Text("Used")
                                }.toggleStyle(CheckboxStyle())
                                Spacer()
                                Toggle(isOn: $viewModel.newCondition) {
                                    Text("New")
                                }.toggleStyle(CheckboxStyle())
                                Spacer()
                                Toggle(isOn: $viewModel.unspecifiedCondition) {
                                    Text("Unspecified")
                                }.toggleStyle(CheckboxStyle())
                                Spacer()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Shipping")
                            HStack {
                                Spacer()
                                Toggle(isOn: $viewModel.localPickup) {
                                    Text("Pickup")
                                }.toggleStyle(CheckboxStyle())
                                Spacer()
                                Toggle(isOn: $viewModel.freeShipping) {
                                    Text("Free Shipping")
                                }.toggleStyle(CheckboxStyle())
                                Spacer()
                            }
                        }
                        
                        HStack {
                            Text("Distance:")
                            TextField("10", text: Binding(get: {
                                String(viewModel.distance)
                            }, set: {
                                viewModel.distance = Int($0) ?? 0
                            }))
                        }
                        
                        VStack {
                            HStack {
                                Text("Custom location")
                                Toggle(isOn: $viewModel.customLocation) {}
                            }
                            if(viewModel.customLocation) {
                                HStack {
                                    Text("Zipcode:")
                                    TextField("Zipcode", text: $viewModel.buyerZipCode)
                                        .transition(.slide)
                                }
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: submitForm) {
                                Text("Submit").padding(10).frame(width: 80)
                            }.buttonStyle(.borderedProminent)
                            Spacer()
                            Button(action: clearAll) {
                                Text("Clear").padding(10).frame(width: 80)
                            }.buttonStyle(.borderedProminent)
                            Spacer()
                        }
                    }
                    
                    Section {
                        if viewModel.showResults {
                            HStack {
                                Text("Results").font(.title).bold()
                            }
                            if(isResultLoading) {
                                HStack {
                                    Spacer()
                                    ProgressView("Please Wait...")
                                        .progressViewStyle(CircularProgressViewStyle())
                                    Spacer()
                                }
                            } else {
                                
                                // Result Table View
                                VStack {
                                    if resultListProducts.isEmpty {
                                        HStack {
                                            Text("No results found.").foregroundColor(.red)
                                        }
                                    } else {
                                        List {
                                            ForEach(resultListProducts.indices, id: \.self) { index in
                                                HStack {
                                                    VStack {
                                                        AsyncImage(url: URL(string: resultListProducts[index].itemImage)) { image in
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
                                                    }
                                                    
                                                    VStack(alignment: .leading, spacing: 5) {
                                                        Text(resultListProducts[index].itemTitle)
                                                            .lineLimit(1)
                                                            .font(.headline)
                                                        
                                                        Text("$\(resultListProducts[index].itemPrice)")
                                                            .fontWeight(.bold)
                                                            .foregroundColor(.blue)
                                                        
                                                        if resultListProducts[index].itemShipping == "Free Shipping" {
                                                            Text("FREE SHIPPING").foregroundColor(.gray)
                                                        } else {
                                                            Text("\(resultListProducts[index].itemShipping)")
                                                                .foregroundColor(.gray)
                                                        }
                                                        
                                                        HStack {
                                                            Text("\(resultListProducts[index].itemZipCode)")
                                                                .foregroundColor(.gray)
                                                            Spacer()
                                                            Text("\(mapCondition(conditionID: resultListProducts[index].itemCondition))")
                                                                .foregroundColor(.gray)
                                                        }
                                                    }
                                                    
                                                    HStack {
                                                        Image(systemName: self.favouriteState[index] ? "heart.fill" : "heart")
                                                            .foregroundColor(.red)
                                                            .frame(width: 25, height: 25).onTapGesture {
                                                                if(self.favouriteState[index]) {
                                                                    removeItemFromWishlist(index: index)
                                                                } else {
                                                                    addItemToWishlist(index: index)
                                                                }
                                                            }
                                                        
                                                        Image(systemName: "chevron.right")
                                                            .foregroundColor(.gray)
                                                            .frame(width: 10, height: 10)
                                                            .padding(.trailing, 10)
                                                    }
                                                }
                                                .onTapGesture {
                                                    print("Navigating to - 225494721576")
                                                    self.selectedItemIndex = true;
                                                }
                                                .navigationDestination(isPresented: $selectedItemIndex, destination: {
                                                    ProductDetailsView(itemId: resultListProducts[index].itemId)
                                                    //ProductDetailsView(itemId:"225494721576")
                                                })
                                            }
                                        }
                                    }
                                }
                                
                                
                                
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $viewModel.showingEmptyKeywordAlert) {
                Alert(
                    title: Text("Empty Keyword"),
                    message: Text("Please enter a keyword."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarItems(trailing: NavigationLink(destination: WishlistView()) {
                Image(systemName: "heart.circle")
                    .foregroundColor(.blue)
            })
            .navigationBarTitle("Product Search")
            .background(Color(.systemBackground))
        }
    }
    
    func submitForm() {
        print("Running Validations...")
        
        guard !viewModel.keywords.isEmpty else {
            print("Show Keyword Alert")
            viewModel.showingEmptyKeywordAlert = true
            return
        }
        
        print("Submit Clicked!")
        
        if viewModel.customLocation {
            print("Using custom location: \(viewModel.buyerZipCode)")
            performSearch()
        } else {
            getCurrentLocationApiCall { result in
                switch result {
                case .success(let postalCode):
                    print("Postal Code: \(postalCode)")
                    viewModel.buyerZipCode = postalCode
                    
                    // Use performSearch on the main thread
                    DispatchQueue.main.async {
                        performSearch()
                    }
                    
                case .failure(let error):
                    print("Failed to get postal code. Error: \(error)")
                }
            }
        }
    }
    
    func performSearch() {
        print("Performing search...")
        let filterObject = generateAndPrintJSON()
        getFindingServiceApiResults(filterObject: filterObject)
        viewModel.showResults = true
        self.clearFormElements()
    }
    
    func clearAll() {
        print("Clear Clicked!")
        clearFormElements()
        clearVariables()
    }
    
    func clearFormElements() {
        viewModel.keywords = ""
        viewModel.buyerZipCode = ""
        viewModel.category = 0
        viewModel.usedCondition = false
        viewModel.newCondition = false
        viewModel.unspecifiedCondition = false
        viewModel.localPickup = false
        viewModel.distance = 10
        viewModel.customLocation = false
    }
    
    func clearVariables() {
        viewModel.showResults = false
        clearResults()
    }
    
    func clearResults() {
        isResultLoading = false
        resultListProducts = []
        favouriteState = []
        print("Results Cleaned!")
    }
    
    func generateAndPrintJSON() -> EbaySearchRequest {
        print("generating Filter Object...")
        let request = EbaySearchRequest.defaultRequest(
            keywords: viewModel.keywords,
            categoryId: viewModel.category,
            buyerPostalCode: viewModel.buyerZipCode,
            maxDistance: viewModel.distance ,
            freeShipping: viewModel.freeShipping,
            localPickup: viewModel.localPickup,
            newCondition: viewModel.newCondition,
            usedCondition: viewModel.usedCondition,
            unspecifiedCondition: viewModel.unspecifiedCondition
        )
        if let jsonString = generateJSONString(request: request) {
            print("Generated Filter Object:\n\(jsonString)")
        }
        
        return request
    }
    
    // API Calls
    private func getFindingServiceApiResults(filterObject: EbaySearchRequest) {
        clearResults()
        self.isResultLoading = true
        getFindingServiceApiCall(filterObject: filterObject) { result in
            switch result {
            case .success(let items):
                //                print("Result items: \(items)")
                self.resultListProducts = items
                favouriteState = [Bool](repeating: false, count: items.count)
                print("Results Updated")
            case .failure(let error):
                print("Error getting result items: \(error)")
            }
            self.isResultLoading = false
        }
    }
    
    private func checkIfAlreadyInWishList(itemIdToSearch: String) -> Bool {
        var currentFavoriteState = false;
        findSingleInWishList(itemId: itemIdToSearch) { result in
            switch result {
            case .success:
                print("Item found in the wishlist.")
                currentFavoriteState = true;
            case .failure(let error):
                print("Error searching for item in wishlist: \(error)")
                currentFavoriteState = false;
            }
        }
        return currentFavoriteState;
    }
    
    private func addItemToWishlist(index: Int) {
        let currentItem = self.resultListProducts[index]
        addWishlistItem(wishlistItem: currentItem) { result in
            switch result {
            case .success(let addedItem):
                print("Successfully added wishlist item: \(addedItem)")
                self.favouriteState[index] = true
            case .failure(let error):
                print("Failed to add wishlist item. Error: \(error)")
                self.favouriteState[index] = false
            }
        }
    }
    
    private func removeItemFromWishlist(index: Int) {
        let currentItem = self.resultListProducts[index]
        deleteWishlistItem(itemId: currentItem.itemId) { result in
            switch result {
            case .success:
                print("Item deleted successfully.")
                self.favouriteState[index] = false
            case .failure(let error):
                print("Error deleting item: \(error)")
                self.favouriteState[index] = true
            }
        }
    }
    
}

#if DEBUG
struct EbaySearchFormView_Previews: PreviewProvider {
    static var previews: some View {
        EbaySearchFormView().environmentObject(SearchFormViewModel())
    }
}
#endif
