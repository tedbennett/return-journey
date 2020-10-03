//
//  UserMapView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 02/10/2020.
//

import SwiftUI
import MapKit

struct UserMapView: View {
    @State private var start = ""
    @State private var end = ""
    
    @State private var startMapMarker: MapMarker?
    @State private var endMapMarker: MapMarker?
    
    var mapMarkers: [Marker] {
        var markers = [Marker]()
        if startMapMarker != nil {
            markers.append(Marker(location: startMapMarker!))
        }
        if endMapMarker != nil {
            markers.append(Marker(location: endMapMarker!))
        }
        return markers
    }
    
    struct Marker: Identifiable {
        let id = UUID()
        var location: MapMarker
    }
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    @State private var results = [MKMapItem]()
    @State private var selectedTextField = TextFieldSelected.none
    
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var keyboard = KeyboardResponder()
    
    enum TextFieldSelected {
        case origin
        case destination
        case none
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    selectedTextField = .none
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 30))
                        .padding(10)
                })
                VStack {
                    TextField("Origin", text: $start, onEditingChanged: { started in
                        if started {
                            results = []
                        }
                        selectedTextField = .origin
                    },
                              onCommit: {
                                let request = MKLocalSearch.Request()
                                request.naturalLanguageQuery = start
                                request.region = region
                                let search = MKLocalSearch(request: request)
                                search.start { response, _ in
                                    guard let response = response else {
                                        return
                                    }
                                    self.results = response.mapItems
                                }
                              }).textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Destination", text: $end, onEditingChanged: { started in
                        results = []
                        selectedTextField = .destination
                    },
                    onCommit: {
                        let request = MKLocalSearch.Request()
                        request.naturalLanguageQuery = end
                        request.region = region
                        let search = MKLocalSearch(request: request)
                        search.start { response, _ in
                            guard let response = response else {
                                return
                            }
                            self.results = response.mapItems
                        }
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10)
                }
            }
            
            if selectedTextField == .none {
                Map(coordinateRegion: $region, showsUserLocation: true,
                    annotationItems: mapMarkers) { marker in
                    marker.location
                }
            } else {
                List {
                    ForEach(results, id: \.self) { result in
                        Button(action: {
                            switch selectedTextField {
                                case .origin:
                                    start = result.placemark.name ?? ""
                                    startMapMarker = MapMarker(coordinate: result.placemark.coordinate)
                                case .destination:
                                    end = result.placemark.name ?? ""
                                    endMapMarker = MapMarker(coordinate: result.placemark.coordinate)
                                case .none: break
                            }
                            if start != "" && end != "" {
                                selectedTextField = .none
                            }
                        }) {
                            Text(result.placemark.name ?? "Unknown Location")
                        }
                    }
                }
            }
        }.navigationTitle("Delivery Route")
        .navigationBarItems(
            trailing: NavigationLink(destination: UserDetailsView()) {
                HStack {
                    Text("Next")
                    Spacer(minLength: 3)
                    Image(systemName: "chevron.right")
                }
            })
        .onAppear {
            if let location = locationManager.location {
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            }
        }
    }
    
    func onSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = start
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.results = response.mapItems
        }
    }
}

struct UserMapView_Previews: PreviewProvider {
    static var previews: some View {
        UserMapView()
    }
}
