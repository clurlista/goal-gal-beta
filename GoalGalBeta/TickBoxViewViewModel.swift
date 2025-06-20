//
//  TickBoxViewViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//

import SwiftUI

class TickBoxViewViewModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var isComplete: Bool
    @Published var isAnimating: Bool = false
    var onStateChanged: (() -> Void)?
    
    init(isComplete: Bool = false, onStateChanged: (() -> Void)? = nil) {
        self.isComplete = isComplete
        self.onStateChanged = onStateChanged
    }
    
    func toggle() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isComplete.toggle()
            animateCompletion()
        }
        onStateChanged?()
    }
    
    private func animateCompletion() {
        isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isAnimating = false
        }
    }
}
