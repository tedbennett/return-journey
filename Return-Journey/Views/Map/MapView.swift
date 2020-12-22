//
//  MapView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 17/12/2020.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        updateMap(mapView)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        updateMap(view)
    }
    
    func updateMap(_ view: MKMapView) {
        view.setRegion(viewModel.region, animated: true)
        let oldAnnotations = view.annotations
        view.removeAnnotations(oldAnnotations)
        view.addAnnotations(viewModel.mapItems)
        
        if let origin = viewModel.origin, let destination = viewModel.destination {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: origin)
            request.destination = MKMapItem(placemark: destination)
            request.transportType = .automobile
            
            let overlays = view.overlays
            view.removeOverlays(overlays)
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else { return }
                
                view.addOverlay(route.polyline)
                view.setVisibleMapRect(
                    route.polyline.boundingMapRect,
                    edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 200, right: 100),
                    animated: true)
            }
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    // Draw polyline
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}
