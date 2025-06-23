//
//  SkillDetailView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 20/06/2025.
//
import SwiftUI

struct SkillDetailView: View {
    @StateObject var viewModel: SkillDetailViewModel
    @State private var showConfetti = false
    @State private var wasCompleted = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(viewModel.skill.name.capitalized)
                    .font(.custom("Digital Arcade Regular", size: 36))
                    .padding()
              
                List {
                    ForEach(viewModel.skill.items, id: \.id) { criteria in
                        CheckPointRow(
                            criteria: criteria,
                            onToggle: {
                                viewModel.toggleCriteria(criteria)
                            }
                        )
                    }
                }
                
                Text(viewModel.isCompleted ? "Completed 🎉" : "In Progress")
                    .font(.custom("Digital Arcade Regular", size: 40))
                    .foregroundColor(viewModel.isCompleted ? .green : .purple)
                    .padding()
            }
            
            if showConfetti {
                ConfettiView(count: 30)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .navigationTitle(viewModel.skill.name.capitalized)
        .onAppear {
            wasCompleted = viewModel.isCompleted
        }
        .onChange(of: viewModel.isCompleted) { newValue in
            if newValue && !wasCompleted {
                triggerConfetti()
            }
            wasCompleted = newValue
        }
    }
    
    private func triggerConfetti() {
        withAnimation {
            showConfetti = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showConfetti = false
            }
        }
    }
}
