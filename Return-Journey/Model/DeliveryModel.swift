//
//  DeliveryModel.swift
//  Return-Journey
//
//  Created by Ted Bennett on 04/10/2020.
//

import Foundation
import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Delivery: Codable, Identifiable {
    var origin: GeoPoint
    var destination: GeoPoint
    
    @DocumentID var id: String?
    var user: String = Auth.auth().currentUser!.uid
    var notes: String
    var name: String
    var height: String
    var width: String
    var depth: String
    var askingPrice: String
    var date: Date

    mutating func setCoordinates(_ origin: CLLocationCoordinate2D, _ destination: CLLocationCoordinate2D) {
        self.origin = GeoPoint(latitude: origin.latitude, longitude: origin.longitude)
        self.destination = GeoPoint(latitude: destination.latitude, longitude: destination.longitude)
    }
    
}

