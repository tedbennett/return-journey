//
//  SlideOverViewModel.swift
//  Return-Journey
//
//  Created by Ted Bennett on 22/12/2020.
//

import SwiftUI

fileprivate struct CardPosition {
    static let bottom: CGFloat = UIScreen.main.bounds.height - 200
    static let top: CGFloat = 50
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    var translation: CGSize {
        switch self {
            case .inactive:
                return .zero
            case .dragging(let translation):
                return translation
        }
    }
    var isDragging: Bool {
        switch self {
            case .inactive:
                return false
            case .dragging:
                return true
        }
    }
}

class SlideOverViewModel: ObservableObject {
    @Published var position = CardPosition.bottom
    
    func offset(_ height: CGFloat) -> CGFloat {
        return max((position + height), CardPosition.top - 20)
    }
    
    func togglePosition() {
        position = position == CardPosition.bottom ? CardPosition.top : CardPosition.bottom
    }
    
    func dismissCard() {
        position = CardPosition.bottom
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func expandCard() {
        position = CardPosition.top
    }
    
    
    func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position + drag.translation.height
        let positionAbove = CardPosition.top
        let positionBelow =  CardPosition.bottom
        var closestPosition = CardPosition.bottom
        
        if (cardTopEdgeLocation - positionAbove) < (positionBelow - cardTopEdgeLocation) {
            closestPosition = CardPosition.top
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = CardPosition.top
        } else {
            self.position = closestPosition
        }
    }
}
