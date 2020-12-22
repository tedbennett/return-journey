//
//  RoutePlannerView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 05/10/2020.
//

import SwiftUI
import MapKit

import SwiftUI

struct RoutePlannerView: View {
    @ObservedObject var routeViewModel: RouteViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var slideOverViewModel: SlideOverViewModel
    
    init(routeViewModel: RouteViewModel) {
        self.routeViewModel = routeViewModel
        mapViewModel = routeViewModel.mapViewModel
        slideOverViewModel = routeViewModel.slideViewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MapView(viewModel: mapViewModel)
                SlideOverCard(viewModel: slideOverViewModel) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Enter Route")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                        TextField("Origin", text: $routeViewModel.origin, onEditingChanged: { unselected in
                            if unselected {
                                routeViewModel.expandCard()
                                routeViewModel.textFieldState = .origin
                            } else {
                                routeViewModel.clearResults()
                                routeViewModel.textFieldState = .none
                            }
                        }, onCommit: {
                            if !routeViewModel.searchResults.isEmpty {
                                routeViewModel.setFromSearch(from: routeViewModel.searchResults.first!)
                            }
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 5)
                        TextField("Destination", text: $routeViewModel.destination, onEditingChanged: { unselected in
                            if unselected {
                                routeViewModel.expandCard()
                                routeViewModel.textFieldState = .destination
                            } else {
                                routeViewModel.clearResults()
                                routeViewModel.textFieldState = .none
                            }
                        }, onCommit: {
                            if !routeViewModel.searchResults.isEmpty {
                                routeViewModel.setFromSearch(from: routeViewModel.searchResults.first!)
                            }
                            routeViewModel.dismissCard()
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal, 5)
                        Text("Note: exact locations are not displayed to other users")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.horizontal, 5)
                        Spacer()
                        List {
                            ForEach(routeViewModel.searchResults) { result in
                                Button(action: {
                                    routeViewModel.setFromSearch(from: result)
                                    routeViewModel.clearResults()
                                    routeViewModel.dismissCard()
                                    
                                    
                                }, label: {
                                    VStack(alignment: .leading) {
                                        Text(result.item.placemark.name ?? "")
                                        Text(result.item.placemark.title ?? "").font(.caption).foregroundColor(.gray)
                                    }
                                })
                            }
                        }//.animation(.none)
                    }.frame(width: geometry.size.width)
                }
            }.edgesIgnoringSafeArea(.vertical)
        }
    }
}

//struct RoutePlannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoutePlannerView()
//    }
//}
