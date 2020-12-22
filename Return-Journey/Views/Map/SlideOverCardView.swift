//
//  SlideOverCardView.swift
//  Return-Journey
//
//  Created by Ted Bennett on 15/12/2020.
//

import SwiftUI

struct SlideOverCard<Content: View> : View {
    @ObservedObject var viewModel: SlideOverViewModel
    @GestureState private var dragState = DragState.inactive
    var content: () -> Content
    
    var body: some View {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(viewModel.onDragEnded)
        return VStack {
            Handle()
            content()
        }
        .frame(height: UIScreen.main.bounds.height)
        .background(Color(.systemGray5))
        .cornerRadius(10.0)
        .offset(y: viewModel.offset(dragState.translation.height))
        .animation(dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag)
    }
    
    
    struct Handle : View {
        private let handleThickness = CGFloat(5.0)
        var body: some View {
            RoundedRectangle(cornerRadius: handleThickness / 2.0)
                .frame(width: 40, height: handleThickness)
                .foregroundColor(.gray)
                .padding(5)
        }
    }
}
