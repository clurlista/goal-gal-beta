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
                let skillVM = SkillDetailViewModel(skill: skill, service: viewModel.service)
                NavigationLink {
                    SkillDetailView(viewModel: skillVM)
                } label: {
                    SkillCard(viewModel: skillVM)
                }
            }
            
        }
    }
    
    struct SkillCard: View {
        @ObservedObject var viewModel: SkillDetailViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(viewModel.skill.name.capitalized)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if viewModel.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                }
                
                HStack {
                    Text("\(viewModel.skill.progress)/\(viewModel.skill.items.count)")
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
                    .stroke(viewModel.isCompleted ? Color.green : Color.clear, lineWidth: 2)
            )
        }
    }
}
