//
//  DeliveriesViewModel.swift
//  Return-Journey
//
//  Created by Ted Bennett on 04/10/2020.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class DeliveriesViewModel: ObservableObject {
    // MARK: - Public properties
    
    @Published var deliveries = [Delivery]()
    
    // MARK: - Firestore
    
    private var db = Firestore.firestore()
    
    func getUsersDeliveries() {
        db.collection("delivery").whereField("user", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.deliveries = documents.compactMap { queryDocumentSnapshot -> Delivery? in
                return try? queryDocumentSnapshot.data(as: Delivery.self)
                
            }
        }
    }
    
    func getAllDeliveries() {
        db.collection("delivery").getDocuments { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.deliveries = documents.compactMap { queryDocumentSnapshot -> Delivery? in
                return try? queryDocumentSnapshot.data(as: Delivery.self)
                
            }
        }
    }
    
}
