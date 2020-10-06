//
//  MapView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 05/10/2020.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.handleSearchCancelled()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 30))
                        .padding(10)
                })
                VStack {
                    TextField("Origin", text: $viewModel.originName, onEditingChanged: { started in
                        if started {
                            viewModel.handleOriginTextFieldSelected()
                        }
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Destination", text:  $viewModel.destinationName, onEditingChanged: { started in
                        if started {
                            viewModel.handleDestinationTextFieldSelected()
                        }
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                }
            }
            
            if viewModel.showMap {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true,
                    annotationItems: viewModel.markers) { marker in
                    marker.location
                }
            } else {
                List {
                    ForEach(viewModel.searchResults.enumerated().map {$0}, id: \.1.self) { index, result in
                        Button(action: {
                            viewModel.handleLocationSelected(index: index)
                            if viewModel.shouldShowMap() {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }) {
                            VStack(alignment: .leading) {
                                Text(result.placemark.name ?? "Unknown Location")
                                Text(parseAddress(selectedItem: result.placemark))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }.onAppear {
            viewModel.updateMapWithCurrentRegion()
        }
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil) ? ", " : ""
        let addressLine = String(
            format:"%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? ""
        )
        return addressLine
    }
}
