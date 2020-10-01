//
//  ContentView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 01/10/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            UserDeliveryListView().tabItem { Image(systemName: "cube.box.fill")
                Text("Deliveries")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
