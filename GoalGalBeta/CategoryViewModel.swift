//
//  CategoryViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//

import SwiftUI
import Combine

class CategoryViewModel: ObservableObject {
    let category: Skill
    @ObservedObject var service: SkillsService
    
    @Published var progress: Int = 0
    @Published private(set) var items: [SkillCriteria] = []
    private var cancellables = Set<AnyCancellable>()
    
    var isCompleted: Bool {
        !items.isEmpty && items.allSatisfy { $0.progress == 5 }
    }
    
    init(category: Skill, service: SkillsService) {
        self.category = category
        self.service = service
        self.items = category.items
        
        // Calculate initial progress - items are complete when they reach 5 progress
        self.progress = category.items.filter { $0.progress == 5 }.count
        
        subscribe()
    }
    
    private func subscribe() {
        service.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self = self,
                      let updatedCategory = categories.first(where: { $0.name == self.category.name }) else { return }
                
                // Update items
                self.items = updatedCategory.items
                
                // Update progress - only count items that have reached 5 progress
                let completedItems = updatedCategory.items.filter { $0.progress == 5 }.count
                if self.progress != completedItems {
                    self.progress = completedItems
                    print(self.progress)
                    
                    // If this update completes the category, notify the service
                    if self.isCompleted {
                        self.service.categoryCompleted(category: self.category)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    var title: String {
        category.name.uppercased()
    }
}
