//
//  SkillView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 21/06/2025.
//
import SwiftUI

struct SkillView: View {
    let viewModel: SkillViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.skill.name)
            Text("\(viewModel.skill.progress)")
        }
        .foregroundStyle(viewModel.isSkillMastered ? .green : .black)
    }
}
