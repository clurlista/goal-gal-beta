//
//  LoadingView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 24/06/2025.
//
import SwiftUI

struct LoadingView: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image("goalgaltransparentlogo")
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300) 
            .scaleEffect(scale)
            .onAppear {
                let baseAnimation = Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)
                withAnimation(baseAnimation) {
                    scale = 1.2
                }
            }
    }
}

