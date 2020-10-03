//
//  UserDeliveryListView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 01/10/2020.
//

import SwiftUI

struct UserDeliveryListView: View {
    var body: some View {
        VStack {
            Text("Hello World!")
        }.navigationTitle("Your Deliveries")
        .navigationBarItems(
            trailing: NavigationLink(destination: UserMapView()) {
                Image(systemName: "plus")
            }
        )
    }
}

struct UserDeliveryListView_Previews: PreviewProvider {
    static var previews: some View {
        UserDeliveryListView()
    }
}
