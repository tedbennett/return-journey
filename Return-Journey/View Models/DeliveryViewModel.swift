//
//  DeliveryModel.swift
//  Return-Journey
//
//  Created by Ted Bennett on 04/10/2020.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class DeliveryViewModel: ObservableObject {
    // MARK: - Public properties
    
    @Published var delivery: Delivery // (1)
    @Published var modified = false
    
    // MARK: - Internal properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constructors
    
    init(delivery: Delivery = Delivery(origin: GeoPoint(latitude: 0, longitude: 0), destination: GeoPoint(latitude: 0, longitude: 0), notes: "", name: "", height: "", width: "", depth: "", askingPrice: "", date: Date())) {
        
        self.delivery = delivery
        self.$delivery // (3)
            .dropFirst() // (5)
            .sink { [weak self] delivery in
                self?.modified = true
            }
            .store(in: &self.cancellables)
        
    }
    
    // MARK: - Firestore
    
    private var db = Firestore.firestore()
    
    func addDelivery(_ delivery: Delivery) {
        do {
            let _ = try db.collection("delivery").addDocument(from: delivery)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Model management
    
    func save() -> Bool {
        if validate() {
            addDelivery(self.delivery)
            return true
        }
        return false
    }
    
    func validate() -> Bool {
        if delivery.name == "" ||
            Double(delivery.height) == nil ||
            Double(delivery.width) == nil ||
            Double(delivery.depth) == nil ||
            Double(delivery.askingPrice) == nil {
            return false
        }
        return true
    }
    
    // MARK: - UI handlers
    
    func handleDoneTapped() -> Bool {
        return self.save()
    }
    
}

private protocol CodableGeoPoint: Codable {
    var latitude: Double { get }
    var longitude: Double { get }
    
    init(latitude: Double, longitude: Double)
}

/** The keys in a GeoPoint. Must match the properties of CodableGeoPoint. */
private enum GeoPointKeys: String, CodingKey {
    case latitude
    case longitude
}

/**
 * An extension of GeoPoint that implements the behavior of the Codable protocol.
 *
 * Note: this is implemented manually here because the Swift compiler can't synthesize these methods
 * when declaring an extension to conform to Codable.
 */
extension CodableGeoPoint {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GeoPointKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GeoPointKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

/** Extends GeoPoint to conform to Codable. */
extension GeoPoint: CodableGeoPoint {}

