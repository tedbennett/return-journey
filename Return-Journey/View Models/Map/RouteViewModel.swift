//
//  MapViewModel.swift
//  ReturnJourney
//
//  Created by Ted Bennett on 22/12/2020.
//

import SwiftUI
import MapKit

class RouteViewModel: ObservableObject {
    var mapViewModel = MapViewModel()
    var slideViewModel = SlideOverViewModel()
    
    enum TextFieldState {
        case origin
        case destination
        case none
    }
    
    struct IdMapItem: Identifiable {
        var id = UUID()
        var item: MKMapItem
    }
    
    @Published var textFieldState = TextFieldState.none
    @Published var searchResults = [IdMapItem]()
    
    @Published var origin = "" {
        didSet {
            updateSearchResults(from: origin)
        }
    }
    @Published var destination = ""{
        didSet {
            updateSearchResults(from: destination)
        }
    }

    func setFromSearch(from location: IdMapItem) {
        let placemark = location.item.placemark
        switch textFieldState {
            case .origin:
                mapViewModel.updateOrigin(placemark)
                origin = placemark.name ?? ""
            case .destination:
                mapViewModel.updateDestination(placemark)
                destination = placemark.name ?? ""
            default: return
        }
    }
    
    func getOrigin() -> CLLocationCoordinate2D? {
        return mapViewModel.origin?.coordinate
    }
    
    func getDestination() -> CLLocationCoordinate2D? {
        return mapViewModel.destination?.coordinate
    }
    
    func dismissCard() {
        slideViewModel.dismissCard()
    }
    
    func expandCard() {
        slideViewModel.expandCard()
    }
    
    func updateSearchResults(from term: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = term
        request.region = mapViewModel.region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, _ in
            guard let response = response else {
                return
            }
            if term == self?.origin || term == self?.destination {
                self?.searchResults = response.mapItems.map {
                    IdMapItem(item: $0)
                }
            }
        }
    }
    
    func clearResults() {
        DispatchQueue.main.async {
            self.searchResults = []
        }
    }
}
