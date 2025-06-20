//
//  CheckPointView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//

import SwiftUI

struct CheckPointView: View {
    @ObservedObject var viewModel: CheckPointViewViewModel
    @State private var showCelebration = false
    @State private var cardScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                // Header with title and progress
                HStack(alignment: .center) {
                    Text(viewModel.displayCheckPoint)
                        .font(.custom("Digital Arcade Regular", size: 24))
                        .foregroundColor(.clear)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Compact progress indicator
                    HStack(spacing: 4) {
                        Text("\(viewModel.checkPointProgress)")
                            .font(.custom("Digital Arcade Regular", size: 24))
                            .foregroundColor(viewModel.isCompleted ? .green : .purple.opacity(0.8))
                        
                        Text("/5")
                            .font(.custom("Digital Arcade Regular", size: 16))
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(.primary.opacity(0.1))
                    )
                }
                
                // Progress indicators with tap gesture
                HStack(spacing: 12) {
                    ForEach(viewModel.tickBoxViewModels) { tickBoxViewModel in
                        TickBoxView(viewModel: tickBoxViewModel)
                            .onTapGesture {
                                // Only allow interaction if checkpoint is not completed
                                guard !viewModel.isCompleted else { return }
                                
                                withAnimation {
                                    if tickBoxViewModel.isComplete {
                                        // If tapping a completed box, decrement progress
                                        viewModel.decrementProgress()
                                    } else {
                                        // If tapping an incomplete box, increment progress
                                        viewModel.incrementProgress()
                                        if viewModel.checkPointProgress == 5 {
                                            celebrate()
                                        }
                                    }
                                }
                            }
                            .opacity(viewModel.isCompleted ? 0.7 : 1.0) // Visual feedback that it's not interactive
                    }
                }
            }
            .padding(12)
            .scaleEffect(cardScale)
            .overlay {
                if showCelebration {
                    ConfettiView(count: 50)
                        .frame(width: 200, height: 200)
                        .allowsHitTesting(false)
                }
            }
        }
        .onChange(of: viewModel.isCompleted) { completed in
            if completed {
                celebrate()
            }
        }
    }
    
    private func celebrate() {
        showCelebration = true
        
        // Animate the card
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            cardScale = 1.1
        }
        
        // Reset animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                cardScale = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showCelebration = false
        }
    }
}
