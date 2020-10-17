//
//  DeliveryDetailView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 04/10/2020.
//

import SwiftUI
import MapKit

struct DeliveryDetailView: View {
    var delivery: Delivery
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var markers = [IdentifiableMapMarker]()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    
    struct IdentifiableMapMarker: Identifiable {
        var location: MapMarker
        var id = UUID()
    }
    
    var body: some View {
        Form {
            List {
                HStack {
                    Text("Dimensions")
                    Spacer()
                    Text("\(delivery.height)x\(delivery.width)x\(delivery.depth) cm")
                }
                HStack {
                    Text("Asking price")
                    Spacer()
                    Text("£\(delivery.askingPrice)")
                }
                    HStack {
                        Text("Expires")
                        Spacer()
                        Text(delivery.date, formatter: dateFormatter)
                    }
                
                if delivery.notes != "" {
                    Section(header: Text("Notes")) {
                        Text(delivery.notes)
                    }
                }
                Map(coordinateRegion: $region, showsUserLocation: true,
                    annotationItems: markers) { marker in
                    marker.location
                }.aspectRatio(contentMode: .fit)
            }
        }.onAppear {
            updateMapView()
            
        }
        .navigationTitle(delivery.name)
    }
    
    func updateMapView() {
        let originLat = delivery.origin.latitude
        let originLong = delivery.origin.longitude
        let destinationLat = delivery.destination.latitude
        let destinationLong = delivery.destination.longitude
        
        markers.append(IdentifiableMapMarker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: originLat, longitude: originLong))))
        markers.append(IdentifiableMapMarker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong))))
        
        let centreLat = ((destinationLat - originLat) / 2) + originLat
        let centreLong = ((destinationLong - originLong) / 2) + originLong
        
        
        let centrePoint = CLLocationCoordinate2D(latitude: centreLat, longitude: centreLong)
        if !CLLocationCoordinate2DIsValid(centrePoint) {
            return
        }
        
        region = MKCoordinateRegion(center: centrePoint, span: MKCoordinateSpan(latitudeDelta: abs(destinationLat - originLat) + 0.1, longitudeDelta: abs(destinationLong - originLong) + 0.1))
    }
}

//struct DeliveryDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        //DeliveryDetailView()
//    }
//}
