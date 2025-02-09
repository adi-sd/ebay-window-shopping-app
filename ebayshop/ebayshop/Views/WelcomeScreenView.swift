//
//  WelcomeScreenView.swift
//  ebayshop
//
//  Created by Aditya Dhage on 12/5/23.
//

import SwiftUI

struct WelcomeScreenView: View {
    var body: some View {
        HStack {
            Text("Powered by")
            Image("ebay")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
        }.onAppear {
            //
        }
    }
}

#Preview {
    WelcomeScreenView()
}
