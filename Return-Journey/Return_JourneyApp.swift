//
//  Return_JourneyApp.swift
//  Return-Journey
//
//  Created by Ted Bennett on 01/10/2020.
//

import Firebase
import SwiftUI

@main
struct Return_JourneyApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
