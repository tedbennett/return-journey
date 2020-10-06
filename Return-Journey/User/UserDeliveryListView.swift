//
//  UserDeliveryListView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 01/10/2020.
//

import SwiftUI

struct UserDeliveryListView: View {
    @StateObject private var viewModel = DeliveriesViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.deliveries) { delivery in
                DeliveryItemView(delivery: delivery)
            }
        }.navigationTitle("Your Deliveries")
        .navigationBarItems(
            trailing: NavigationLink(destination: UserMapView()) {
                Image(systemName: "plus")
            }
        )
        .onAppear {
            viewModel.getUsersDeliveries()
        }
    }
}

struct UserDeliveryListView_Previews: PreviewProvider {
    static var previews: some View {
        UserDeliveryListView()
    }
}

struct DeliveryItemView: View {
    var delivery: Delivery
    
    var body: some View {
        NavigationLink(destination: DeliveryDetailView(delivery: delivery)) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5))
                HStack {
                    VStack {
                        Text(delivery.name).font(.title3)
                    }
                    Spacer()
                    Text("£\(delivery.askingPrice)")
                }.padding(20)
            }
        }
    }
}
