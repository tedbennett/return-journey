//
//  DeliveryMapView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 05/10/2020.
//

import SwiftUI
import CoreLocation

struct DeliveryMapView: View {
    @ObservedObject var viewModel = MapViewModel()
    var body: some View {
        MapView(viewModel: viewModel)
            .navigationTitle("Return Journey")
            .navigationBarItems(
                trailing: NavigationLink(destination: DeliveryListView(origin: viewModel.origin ?? CLLocationCoordinate2D(), destination: viewModel.destination ?? CLLocationCoordinate2D())) {
                    HStack {
                        Text("Next")
                        Spacer(minLength: 3)
                        Image(systemName: "chevron.right")
                    }
                }.disabled(viewModel.origin == nil || viewModel.destination == nil)
            )
    }
}

struct DeliveryMapView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryMapView()
    }
}
