//
//  DeliveryListView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 05/10/2020.
//

import SwiftUI
import CoreLocation

struct DeliveryListView: View {
    @ObservedObject var viewModel = DeliveriesViewModel()
    
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    
    func separation(delivery: Delivery) -> Double {
        let location1 = CLLocation(latitude: origin.latitude, longitude: origin.longitude)
        let location2 = CLLocation(latitude: delivery.origin.latitude, longitude: delivery.origin.longitude)
        
        let location3 = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let location4 = CLLocation(latitude: delivery.destination.latitude, longitude: delivery.destination.longitude)
        
        return abs(location1.distance(from: location2)) + abs(location3.distance(from: location4))
    }
    
    var body: some View {
        List {
            ForEach(viewModel.deliveries.sorted {
                return separation(delivery: $0) < separation(delivery: $1)
            }) { delivery in
                CourierDeliveryItemView(delivery: delivery, separation: separation(delivery: delivery))
            }
        }.navigationTitle("Nearest Journeys")
        .onAppear {
            viewModel.getAllDeliveries()
        }
    }
}

struct CourierDeliveryItemView: View {
    var delivery: Delivery
    var separation: Double
    
    var body: some View {
        NavigationLink(destination: DeliveryDetailView(delivery: delivery)) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5))
                HStack {
                    VStack(alignment: .leading) {
                        Text(delivery.name).font(.title3)
                        Text("\(Int(separation) / 1000)km added to your journey").font(.caption).foregroundColor(.gray)
                    }
                    Spacer()
                    Text("£\(delivery.askingPrice)")
                }.padding(20)
            }
        }
    }
}

