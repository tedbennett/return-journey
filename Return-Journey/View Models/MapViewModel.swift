//
//  MapViewModel.swift
//  Return-Journey
//
//  Created by Ted Bennett on 05/10/2020.
//

import SwiftUI
import Combine
import MapKit

class MapViewModel: ObservableObject {
    
    struct IdentifiableMapMarker: Identifiable {
        let id = UUID()
        var location: MapMarker
        
        init(from coord: CLLocationCoordinate2D) {
            self.location = MapMarker(coordinate: coord)
        }
    }
    
    enum TextFieldSelected {
        case origin
        case destination
        case none
    }
    
    // Default location is London, UK
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @Published private(set) var origin: CLLocationCoordinate2D?
    @Published private(set) var destination: CLLocationCoordinate2D?
    
    @Published var originName = "" {
        didSet {
            updateSearchResults(from: originName)
        }
    }
    @Published var destinationName = "" {
        didSet {
            updateSearchResults(from: destinationName)
        }
    }
    
    @Published private(set) var searchResults = [MKMapItem]()

    var markers: [IdentifiableMapMarker] {
        var markers = [IdentifiableMapMarker]()
        if origin != nil {
            markers.append(IdentifiableMapMarker(from: origin!))
        }
        if destination != nil {
            markers.append(IdentifiableMapMarker(from: destination!))
        }
        return markers
    }
    
    private var selectedTextField = TextFieldSelected.none
    
    private var locationManager = LocationManager()
    
    var showMap: Bool {
        return selectedTextField == .none
    }

    // MARK: - Model
    
    func updateSearchResults(from term: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = term
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let response = response else {
                return
            }
            self?.searchResults = response.mapItems
        }
    }
    
    func updateMap() {
        guard let originLat = origin?.latitude, let originLong = origin?.longitude else {
            return
        }
        guard let destinationLat = destination?.latitude, let destinationLong = destination?.longitude else {
            return
        }
        
        let centreLat = ((destinationLat - originLat) / 2) + originLat
        let centreLong = ((destinationLong - originLong) / 2) + originLong
        
        let centrePoint = CLLocationCoordinate2D(latitude: centreLat, longitude: centreLong)
        if !CLLocationCoordinate2DIsValid(centrePoint) {
            return
        }
        
        region = MKCoordinateRegion(center: centrePoint, span: MKCoordinateSpan(latitudeDelta: abs(destinationLat - originLat) + 0.1, longitudeDelta: abs(destinationLong - originLong) + 0.1))
    }
    
    
    func changeSelectedTextField(to selected: TextFieldSelected) {
        selectedTextField = selected
        searchResults = []
        updateMap()
    }
    
    func updateLocation(index: Int) {
        let location = searchResults[index]
        switch selectedTextField {
            case .origin:
                originName = location.placemark.name ?? ""
                origin = location.placemark.coordinate
            case .destination:
                destinationName = location.placemark.name ?? ""
                destination = location.placemark.coordinate
            case .none: return
        }
        searchResults = []
    }
    
    func shouldDeselectTextField() -> Bool {
        return (origin != nil) && (destination != nil)
    }
    
    func setMapWithCurrentRegion() {
        if let location = locationManager.location {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        }
    }
    
    // MARK:- UI

    func handleLocationSelected(index: Int) {
        guard index < searchResults.count else {
            return
        }
        updateLocation(index: index)
    }
    
    func handleOriginTextFieldSelected() {
        changeSelectedTextField(to: .origin)
    }
    
    func handleDestinationTextFieldSelected() {
        changeSelectedTextField(to: .destination)
    }
    
    func handleSearchCancelled() {
        changeSelectedTextField(to: .none)
    }
    
    func shouldShowMap() -> Bool {
        return !shouldDeselectTextField()
    }
    
    func updateMapWithCurrentRegion() {
        setMapWithCurrentRegion()
    }
}
