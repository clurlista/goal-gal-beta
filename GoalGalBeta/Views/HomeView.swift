//
//  HomeView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(service: SkillsService) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(service: service))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("⚽️  GoalGal  ⚽️")
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
                                    ForEach(viewModel.fullyCompletedSkills) { skill in
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
            ForEach(viewModel.skills) { skill in
                NavigationLink {
                    let skillVM = SkillDetailViewModel(skill: skill, service: viewModel.service)
                    SkillDetailView(viewModel: skillVM)
                } label: {
                    SkillCard(skill: skill)
                        .id(skill)
                }
            }
        }
    }
    
    struct SkillCard: View {
        var skill: Skill
        
        init(skill: Skill) {
            self.skill = skill
            print("🧩 Skill passed to SkillCard: \(skill.name), progress: \(skill.progress)/\(skill.items.count)")
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(skill.name.capitalized)
                        .font(.custom("Menlo", size: 15))
                        .foregroundColor(.primary)
                    Spacer()
                    if skill.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                }
                
                HStack {
                    Text("\(skill.progress)/\(skill.items.count)")
                        .font(.custom("Digital Arcade Regular", size: 20))
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
                    .stroke(skill.isCompleted ? Color.green : Color.clear, lineWidth: 2)
            )
        }
    }
}
