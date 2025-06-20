//
//  SkillDetailView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 20/06/2025.
//
import SwiftUI

struct SkillDetailView: View {
    @ObservedObject var viewModel: SkillDetailViewModel
    @State private var showConfetti = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(viewModel.skill.name.capitalized)
                    .font(.custom("Digital Arcade Regular", size: 32))
                    .foregroundColor(.purple)
                    .padding(.bottom, 10)
                
                ForEach(viewModel.checkPointViewModels) { checkpointVM in
                    CheckPointView(viewModel: checkpointVM)
                }
            }
        }
        .padding()
        .overlay(
            Group {
                if showConfetti {
                    ConfettiView(count: 100)
                        .frame(width: 300, height: 300)
                        .transition(.scale)
                        .animation(.easeOut, value: showConfetti)
                }
            }
        )
        .onReceive(viewModel.$isCompleted) { completed in
            if completed {
                celebrate()
            }
        }
    }
    
    private func celebrate() {
        showConfetti = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showConfetti = false
        }
    }
}


