//
//  HomeView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI
import Foundation

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    let service: SkillsService

    init(service: SkillsService) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(service: service))
        self.service = service
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("GoalGal")
                        .font(.custom("Digital Arcade Regular", size: 36))
                        .foregroundColor(.purple)
                    
                    if !viewModel.fullyCompletedSkills.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mastered Skills")
                                .font(.custom("Digital Arcade Regular", size: 24))
                                .foregroundColor(.purple)
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.fullyCompletedSkills, id: \.id) { skill in
                                        MasteredSkillView(skill: skill)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    skillsGrid
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var skillsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(viewModel.categories) { skill in
                let skillViewModel = SkillDetailViewModel(skill: skill, service: service)

                NavigationLink {
                    SkillDetailView(viewModel: skillViewModel)
                } label: {
                    SkillCard(
                        viewModel: skillViewModel,
                        isCompleted: viewModel.completedCategories.contains(skill.name)
                    )
                }
            }
        }
    }
}

struct SkillCard: View {
    @ObservedObject var viewModel: SkillDetailViewModel
    let isCompleted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(viewModel.skill.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .imageScale(.large)
                }
            }

            // Completion count
            HStack {
                Text("\(completedItems)/\(totalItems)")
                    .font(.custom("Digital Arcade Regular", size: 10))
                    .foregroundColor(.purple)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.purple)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCompleted ? Color.green : Color.clear, lineWidth: 2)
        )
    }

    private var completedItems: Int {
        viewModel.skill.items.filter { $0.isCompleted }.count
    }

    private var totalItems: Int {
        viewModel.skill.items.count
    }
}
