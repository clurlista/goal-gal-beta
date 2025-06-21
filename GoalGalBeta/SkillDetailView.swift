//
//  SkillDetailView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI

struct SkillDetailView: View {
    let viewModel: SkillViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.skill.name)
            Text(viewModel.steps)
            
            Text("\(viewModel.skill.progress)")
                .foregroundStyle(viewModel.isSkillMastered ? .green : .black)
            
            Button("Increment") {
                viewModel.increaseProgress()
            }
            
            Button("Decrement") {
                viewModel.decreaseProgress()
            }
        }
    }
}

