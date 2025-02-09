//
//  ContentView.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/4/23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @State private var showWelcomeScreen = false
    
    var body: some View {
//        NavigationStack {
//            WelcomeScreenView()
//                .onAppear {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        showWelcomeScreen = true
//                    }
//                }
//                .navigationDestination(isPresented: $showWelcomeScreen, destination: {
//                    EbaySearchFormView().navigationBarBackButtonHidden(true)
//                })
//        }
        
        EbaySearchFormView()
        
    }
}

#Preview {
    ContentView()
}
