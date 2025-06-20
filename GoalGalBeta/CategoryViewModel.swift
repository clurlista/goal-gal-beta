//
//  CategoryViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI
import Combine

class CategoryViewModel: ObservableObject {
    @Published private(set) var category: Skill
    private let service: SkillsService
    
    // Expose items and progress for the UI
    @Published var items: [SkillCriteria] = []
    @Published var progress: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    var isCompleted: Bool {
        !items.isEmpty && items.allSatisfy { $0.isCompleted }
    }
    
    var title: String {
        category.name.uppercased()
    }
    
    init(category: Skill, service: SkillsService) {
        self.category = category
        self.service = service
        
        // Initialize local state
        self.items = category.items
        self.progress = category.items.filter { $0.isCompleted }.count
        
        subscribeToService()
    }
    
    private func subscribeToService() {
        service.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self = self,
                      let updatedCategory = categories.first(where: { $0.id == self.category.id }) else { return }
                
                // Update local state to match service
                self.category = updatedCategory
                self.items = updatedCategory.items
                self.progress = updatedCategory.items.filter { $0.isCompleted }.count
                
                // Notify service if the category is completed
                if self.isCompleted {
                    self.service.categoryCompleted(category: updatedCategory)
                }
            }
            .store(in: &cancellables)
    }
    
    /// Toggle the completion state of a SkillCriteria and notify the service.
    func toggleCriteriaCompletion(_ criteria: SkillCriteria) {
        // Create a new updated criteria with toggled isCompleted, preserving the id
        let updatedCriteria = SkillCriteria(
            id: criteria.id,
            name: criteria.name,
            isCompleted: !criteria.isCompleted
        )
        
        // Send the update to the service
        service.updateProgress(for: updatedCriteria)
    }
}
