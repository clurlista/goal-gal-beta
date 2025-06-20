//
//  HomeViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var categories: [Skill] = []
    @Published private(set) var completedCategories: Set<String> = []
    private let service: SkillsService
    private var cancellables = Set<AnyCancellable>()
    
    // UserDefaults keys
    private enum UserDefaultsKeys {
        static let completedCategories = "completedCategories"
    }
    
    init(service: SkillsService) {
        self.service = service
        
        loadCompletedCategories()
        
        // Subscribe to category updates
        service.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.categories = categories
            }
            .store(in: &cancellables)
        
        // Subscribe to category completion
        service.categoryCompletedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] category in
                self?.handleCategoryCompletion(category)
            }
            .store(in: &cancellables)
    }
    
    private func loadCompletedCategories() {
        if let savedCategories = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.completedCategories) {
            completedCategories = Set(savedCategories)
        }
    }
    
    private func saveCompletedCategories() {
        UserDefaults.standard.set(Array(completedCategories), forKey: UserDefaultsKeys.completedCategories)
    }
    
    private func handleCategoryCompletion(_ category: Skill) {
        if !completedCategories.contains(category.name) {
            completedCategories.insert(category.name)
            saveCompletedCategories()
        }
    }
}

extension HomeViewModel {
    
    var fullyCompletedSkills: [Skill] {
        categories.filter { !$0.items.isEmpty && $0.items.allSatisfy { $0.progress == 5 } }
    }

    /// Returns the first mastered skill criteria (progress == 5) from any skill
    var firstMasteredSkillCriteria: (skill: Skill, criteria: SkillCriteria)? {
        for skill in categories {
            if let masteredCriteria = skill.items.first(where: { $0.progress == 5 }) {
                return (skill, masteredCriteria)
            }
        }
        return nil
    }
}


