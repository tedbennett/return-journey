//
//  UserDetailsView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 03/10/2020.
//

import SwiftUI

struct UserDetailsView: View {
    @State private var notes = ""
    @State private var name = ""
    @State private var weight = ""
    @State private var height = ""
    @State private var width = ""
    @State private var depth = ""
    @State private var askingPrice = ""
    
    var body: some View {
        Form {
            List {
                Section(header: Text("Name")) {
                TextField("Name", text: $name)
                }
                Section(header: Text("Weight")) {
                TextField("Weight (kg)", text: $weight).keyboardType(.numberPad)
                }
                Section(header: Text("Dimensions (cm)")) {
                    HStack(alignment: .center) {
                        TextField("Height", text: $height).keyboardType(.numberPad)
                        TextField("Width", text: $width).keyboardType(.numberPad)
                        TextField("Depth", text: $depth).keyboardType(.numberPad)
                    }
                }
                TextField("Estimated Price", text: $askingPrice).keyboardType(.numberPad)
            }
        }.navigationTitle("Item Details")
    }
}


struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
    }
}
