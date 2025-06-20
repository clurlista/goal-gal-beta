//
//  HomeView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    let service: SkillsService

    init(service: SkillsService) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(service: service))
        self.service = service
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        
                        Text("GoalGal")
                            .font(.custom("Digital Arcade Regular", size: 36))
                            .foregroundColor(.purple)

                        if let completedSkill = viewModel.firstFullyCompletedSkill {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mastered Skill")
                                    .font(.custom("Digital Arcade Regular", size: 24))
                                    .foregroundColor(.purple)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)

                                MasteredSkillView(skill: completedSkill)
                                    .padding(.horizontal)
                            }
                        }

                        // Categories grid
                        categoriesGrid
                            .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    private var categoriesGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(viewModel.categories, id: \.self) { category in
                let categoryViewModel = CategoryViewModel(category: category, service: service)

                NavigationLink {
                    CheckpointsView(viewModel: categoryViewModel)
                } label: {
                    CategoryCard(
                        viewModel: categoryViewModel,
                        isCompleted: viewModel.completedCategories.contains(category.name)
                    )
                }
            }
        }
    }
}

struct CategoryCard: View {
    @ObservedObject var viewModel: CategoryViewModel
    let isCompleted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(viewModel.category.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .imageScale(.large)
                }
            }
            
            ProgressView(value: progress)
                .tint(progress == 1 ? .purple : .pink)
            
            HStack {
                Text("\(viewModel.category.items.filter { $0.progress == 5 }.count)/\(viewModel.category.items.count)")
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

    private var progress: Double {
        let completedItems = viewModel.category.items.filter { $0.progress == 5 }.count
        return viewModel.category.items.isEmpty ? 0 : Double(completedItems) / Double(viewModel.category.items.count)
    }
}



