//
//  ebayshopApp.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/4/23.
//

import SwiftUI

@main
struct ebayshopApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                WelcomeScreenView()
                    .opacity(showSplash ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.5)) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSplash = false
                            }
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
