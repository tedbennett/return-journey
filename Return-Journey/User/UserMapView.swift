//
//  UserMapView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 02/10/2020.
//

import SwiftUI
import MapKit

struct UserMapView: View {
    @ObservedObject var viewModel = MapViewModel()

    var body: some View {
        MapView(viewModel: viewModel)
        .navigationTitle("Delivery Route")
        .navigationBarItems(
            trailing: NavigationLink(destination: UserDetailsView(origin: viewModel.origin ?? CLLocationCoordinate2D(), destination: viewModel.destination ?? CLLocationCoordinate2D())) {
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
