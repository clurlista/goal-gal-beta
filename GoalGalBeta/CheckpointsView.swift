//
//  CheckpointsView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//

import SwiftUI

struct CheckpointsView: View {
    @ObservedObject private var viewModel: CategoryViewModel
    @State private var showCategoryCelebration = false
    @State private var cardScale: CGFloat = 1.0
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 12) {
                    // Progress Header
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Category Progress")
                                .font(.custom("Digital Arcade Regular", size: 24))
                                .foregroundColor(.gray.opacity(0.6))
                            
                            Text("\(Int(progress * 100))%")
                                .font(.custom("Digital Arcade Regular", size: 24))
                                .foregroundColor(.purple)
                        }
                        
                        Spacer()
                        
                        // Quick stats
                        statsCard(title: "Complete", value: "\(completedItems)", color: .green)
                        statsCard(title: "Remaining", value: "\(remainingItems)", color: .pink.opacity(0.8))
                    }
                    .padding(.horizontal)
                    .scaleEffect(cardScale)
                    
                    // Checkpoints
                    ForEach(viewModel.items, id: \.self) { checkPoint in
                        let checkPointViewModel = CheckPointViewViewModel(checkPoint: checkPoint, service: viewModel.service)
                        CheckPointView(viewModel: checkPointViewModel)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color("BackgroundColor").ignoresSafeArea())
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.large)
            
            // Category completion celebration
            if showCategoryCelebration {
                ZStack {
                    // Multiple confetti views for a more dramatic effect
                    ConfettiView(count: 100)
                        .frame(width: 300, height: 300)
                        .allowsHitTesting(false)
                    
                    ConfettiView(count: 75)
                        .frame(width: 250, height: 250)
                        .allowsHitTesting(false)
                        .offset(x: 20, y: -20)
                    
                    ConfettiView(count: 75)
                        .frame(width: 250, height: 250)
                        .allowsHitTesting(false)
                        .offset(x: -20, y: 20)
                }
            }
        }
        .onChange(of: viewModel.isCompleted) { completed in
            if completed {
                celebrateCategory()
            }
        }
    }
    
    private var progress: Double {
        let completedItems = viewModel.items.filter { $0.progress == 5 }.count
        return viewModel.items.isEmpty ? 0 : Double(completedItems) / Double(viewModel.items.count)
    }
    
    private var completedItems: Int {
        viewModel.items.filter { $0.progress == 5 }.count
    }
    
    private var remainingItems: Int {
        viewModel.items.filter { $0.progress < 5 }.count
    }
    
    private func statsCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.custom("Digital Arcade Regular", size: 30))
                .foregroundColor(color)
            
            Text(title)
                .font(.custom("Digital Arcade Regular", size: 20))
                .foregroundColor(.gray.opacity(0.6))
        }
        .frame(width: 80)
    }
    
    private func celebrateCategory() {
        showCategoryCelebration = true
        
        // Animate the card with a bigger scale
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
            cardScale = 1.2
        }
        
        // Reset animations with a longer duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                cardScale = 1.0
            }
        }
        
        // Keep the celebration going longer
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            showCategoryCelebration = false
        }
    }
}
