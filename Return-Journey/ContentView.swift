//
//  ContentView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 01/10/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var needSignIn = true
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: UserDeliveryListView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.purple)
                            .frame(width: 200, height: 200)
                        VStack {
                            Image(systemName: "shippingbox.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 100))
                                .padding(20)
                            Text("Need a delivery?")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                        }.frame(width: 200, height: 200)
                    }
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color.purple)
                        .frame(width: 200, height: 200)
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 100))
                        .frame(width: 200, height: 200)
                }
                Spacer()
            }.sheet(isPresented: $needSignIn) {
                SignInView(presented: $needSignIn)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
