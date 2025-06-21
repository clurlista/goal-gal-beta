//
//  CategoryViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI

@MainActor
class CategoryViewModel: ObservableObject {
    @Published private(set) var category: Skill
    @Published var items: [SkillCriteria]
    @Published var progress: Int
    
    @ObservedObject private var service: SkillsService
    
    var isCompleted: Bool {
        !items.isEmpty && items.allSatisfy { $0.isCompleted }
    }
    
    var title: String {
        category.name.uppercased()
    }
    
    init(category: Skill, service: SkillsService) {
        self.category = category
        self.service = service
        
        self.items = category.items
        self.progress = category.items.filter { $0.isCompleted }.count
        
        // Update whenever service.skills changes (SwiftUI will re-initialize views or view models)
        updateFromService()
    }
    
    func updateFromService() {
        if let updatedCategory = service.skills.first(where: { $0.id == category.id }) {
            category = updatedCategory
            items = updatedCategory.items
            progress = updatedCategory.items.filter { $0.isCompleted }.count
            
            if isCompleted {
                service.categoryCompleted(category: updatedCategory)
            }
        }
    }
    
    func toggleCriteriaCompletion(_ criteria: SkillCriteria) {
        let updatedCriteria = SkillCriteria(
            id: criteria.id,
            name: criteria.name,
            isCompleted: !criteria.isCompleted
        )
        service.updateProgress(for: category, criteria: updatedCriteria)
        updateFromService()
    }
}
