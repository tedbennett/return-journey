//
//  MapViewModel.swift
//  Return-Journey
//
//  Created by Ted Bennett on 05/10/2020.
//

import SwiftUI
import MapKit

class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.71, longitude: -74),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published private(set) var origin: MKPlacemark?
    @Published private(set) var destination: MKPlacemark?
    
    var mapItems: [MKPlacemark] {
        var items = [MKPlacemark]()
        if let origin = origin {
            items.append( origin)
        }
        if let destination = destination {
            items.append(destination)
        }
        return items
    }
    
    func updateOrigin(_ location: MKPlacemark) {
        origin = location
        refreshRegion()
    }
    
    func updateDestination(_ location: MKPlacemark) {
        destination = location
    }
    
    func refreshRegion() {
        guard let origin = origin?.coordinate else {
            return
        }
        guard let destination = destination?.coordinate else {
            // Only origin so center map around here.
            region = MKCoordinateRegion(
                center: origin,
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            return
        }
        
        let centreLat = ((destination.latitude - origin.latitude) / 2) + origin.latitude
        let centreLong = ((destination.longitude - origin.longitude) / 2) + origin.longitude
        
        let centrePoint = CLLocationCoordinate2D(latitude: centreLat, longitude: centreLong)
        
        if !CLLocationCoordinate2DIsValid(centrePoint) {
            return
        }
        
        region = MKCoordinateRegion(center: centrePoint, span: MKCoordinateSpan(latitudeDelta: abs(destination.latitude - origin.longitude) + 0.1, longitudeDelta: abs(destination.longitude - origin.longitude) + 0.1))
    }
    
}

