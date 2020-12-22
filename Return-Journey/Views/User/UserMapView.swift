//
//  UserMapView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 02/10/2020.
//

import SwiftUI
import MapKit

struct UserMapView: View {
    @ObservedObject var viewModel = RouteViewModel()

    var body: some View {
        RoutePlannerView(routeViewModel: viewModel)
        .navigationTitle("Delivery Route")
        .navigationBarItems(
            trailing: NavigationLink(destination: UserDetailsView(origin: viewModel.getOrigin() ?? CLLocationCoordinate2D(), destination: viewModel.getDestination() ?? CLLocationCoordinate2D())) {
                HStack {
                    Text("Next")
                    Spacer(minLength: 3)
                    Image(systemName: "chevron.right")
                }
            }.disabled(viewModel.origin == nil || viewModel.destination == nil)
        )
    }
}

struct UserMapView_Previews: PreviewProvider {
    static var previews: some View {
        UserMapView()
    }
}
