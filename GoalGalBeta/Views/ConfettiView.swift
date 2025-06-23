//
//  ConfettiView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//

import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var rotation: Double
    var color: Color
    var scale: CGFloat
    var speed: Double
    
    static func random(in rect: CGRect) -> ConfettiPiece {
        let colors: [Color] = [.blue, .purple, .pink, .orange, .yellow, .green]
        return ConfettiPiece(
            x: rect.midX,
            y: rect.midY,
            rotation: Double.random(in: 0...360),
            color: colors.randomElement() ?? .blue,
            scale: CGFloat.random(in: 0.5...1.5),
            speed: Double.random(in: 0.8...1.2)
        )
    }
}

struct ConfettiView: View {
    let count: Int
    @State private var pieces: [ConfettiPiece] = []
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(pieces) { piece in
                    Rectangle()
                        .fill(piece.color)
                        .frame(width: 8, height: 8)
                        .scaleEffect(piece.scale)
                        .position(
                            x: piece.x + CGFloat.random(in: -50...50),
                            y: piece.y - 100 * piece.speed
                        )
                        .rotationEffect(.degrees(piece.rotation))
                }
            }
            .onAppear {
                // Create initial pieces at the center
                pieces = (0..<count).map { _ in
                    ConfettiPiece.random(in: geometry.frame(in: .local))
                }
                
                // Initial pop animation
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    scale = 1.0
                }
                
                // Animate each piece
                for index in pieces.indices {
                    withAnimation(
                        .easeOut(duration: 1)
                        .delay(Double.random(in: 0...0.3))
                    ) {
                        pieces[index].y = geometry.size.height * 0.2
                        pieces[index].rotation += Double.random(in: 180...360)
                        pieces[index].x += CGFloat.random(in: -50...50)
                    }
                }
                
                // Fade out
                withAnimation(.easeInOut(duration: 0.7).delay(0.5)) {
                    opacity = 0
                }
            }
        }
        .scaleEffect(scale)
        .opacity(opacity)
    }
}
