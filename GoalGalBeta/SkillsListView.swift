//
//  SkillsListView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//

import SwiftUI

struct SkillsListView: View {
    @ObservedObject var viewModel: SkillsListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(viewModel.skillsViewModels, id: \.skill.id) { viewModel in
                    NavigationLink {
                        SkillDetailView(viewModel: viewModel)
                    } label: {
                        SkillView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Skills")
        }
    }
}
