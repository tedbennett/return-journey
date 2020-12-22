//
//  DeliveryMapView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 05/10/2020.
//

import SwiftUI
import CoreLocation

struct DeliveryMapView: View {
    @ObservedObject var viewModel = RouteViewModel()
    var body: some View {
        RoutePlannerView(routeViewModel: viewModel)
            .navigationTitle("Return Journey")
            .navigationBarItems(
                trailing: NavigationLink(destination: DeliveryListView(origin: viewModel.getOrigin() ?? CLLocationCoordinate2D(), destination: viewModel.getDestination() ?? CLLocationCoordinate2D())) {
                    HStack {
                        Text("Next")
                        Spacer(minLength: 3)
                        Image(systemName: "chevron.right")
                    }
                }.disabled(viewModel.getOrigin() == nil || viewModel.getDestination() == nil )
            )
    }
}

struct DeliveryMapView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryMapView()
    }
}
