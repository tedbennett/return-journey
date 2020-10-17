//
//  UserDetailsView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 03/10/2020.
//

import SwiftUI
import CoreLocation

struct UserDetailsView: View {
    var origin: CLLocationCoordinate2D
    var destination: CLLocationCoordinate2D
    
    @Environment(\.presentationMode) var presentation
    
    @State private var failedToSubmit = false
    @StateObject private var viewModel = DeliveryViewModel()
    
    var body: some View {
        VStack {
        Form {
            List {
                Section(header: Text("Name")) {
                    TextField("Name", text: $viewModel.delivery.name)
                }
                Section(header: Text("Dimensions (cm)")) {
                    HStack(alignment: .center) {
                        TextField("Height", text: $viewModel.delivery.height).keyboardType(.numberPad)
                        TextField("Width", text: $viewModel.delivery.width).keyboardType(.numberPad)
                        TextField("Depth", text: $viewModel.delivery.depth).keyboardType(.numberPad)
                    }
                }
                Section(header: Text("Estimated Price")) {
                    TextField("Estimated Price", text: $viewModel.delivery.askingPrice).keyboardType(.numberPad)
                }
                Section(header: Text("Notes")) {
                    TextEditor(text: $viewModel.delivery.notes)
                }
                Section(header: Text("Expiry Date")) {
                    DatePicker("Expiry", selection: $viewModel.delivery.date, displayedComponents: .date)
                }
            }
            
        }.onAppear {
            viewModel.delivery.setCoordinates(origin, destination)
        }
        .navigationTitle("Item Details")
            Button(action: {
                if !viewModel.handleDoneTapped() {
                    failedToSubmit = true
                } else {
                    failedToSubmit = false
                    self.presentation.wrappedValue.dismiss()
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color.purple)
                        .frame(width: 300, height: 50)
                        
                    Text("Done").foregroundColor(.white)
                        .font(.title2)
                }
            }).padding(20)
        }
    }
}


//struct UserDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailsView()
//    }
//}
