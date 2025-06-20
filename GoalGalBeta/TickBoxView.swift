//
//  TickBoxView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 20/06/2023.
//

import SwiftUI

struct TickBoxView: View {
    @ObservedObject var viewModel: TickBoxViewViewModel
    @State private var scale: CGFloat = 1
    
    private var gradient: LinearGradient {
        LinearGradient(
            colors: viewModel.isComplete ? 
                [.purple.opacity(0.8), .pink.opacity(0.8)] :
                [.gray.opacity(0.6), .gray.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        Circle()
            .fill(gradient)
            .frame(width: 30, height: 30)
            .overlay(
                Circle()
                    .stroke(gradient, lineWidth: 2)
            )
            .overlay(
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(viewModel.isComplete ? 1 : 0)
                    .scaleEffect(viewModel.isAnimating ? 1.2 : 1)
            )
            .scaleEffect(scale)
            .animation(
                .spring(response: 0.6, dampingFraction: 0.8),
                value: viewModel.isComplete
            )
            .onChange(of: viewModel.isComplete) { newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.2
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            scale = 1.0
                        }
                    }
                }
            }
    }
}

// Preview provider for SwiftUI canvas
struct TickBoxView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TickBoxView(viewModel: TickBoxViewViewModel(isComplete: false))
            TickBoxView(viewModel: TickBoxViewViewModel(isComplete: true))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
