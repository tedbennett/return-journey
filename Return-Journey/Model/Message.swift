//
//  Message.swift
//  Return-Journey
//
//  Created by Ted Bennett on 15/10/2020.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var text: String
    var received: Bool
    var sentAt: Date
}
