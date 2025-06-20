//
//  SkillDetailViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 20/06/2025.
//
import SwiftUI
import Combine

class SkillDetailViewModel: ObservableObject {
    @Published var skill: Skill
    @Published var criterionViewModels: [SkillCriteriaViewModel]
    @Published var isCompleted: Bool = false

    private let service: SkillsService
    private var cancellables = Set<AnyCancellable>()

    init(skill: Skill, service: SkillsService) {
        self.skill = skill
        self.service = service
        self.criterionViewModels = skill.items.map { SkillCriteriaViewModel(criterion: $0) }

        $criterionViewModels
            .map { $0.allSatisfy { $0.criterion.progress == 5 } }
            .assign(to: &$isCompleted)
    }

    func updateProgress(for criterion: SkillCriteria) {
        if let index = skill.items.firstIndex(where: { $0.id == criterion.id }) {
            skill.items[index].progress = criterion.progress
        }

        if let index = criterionViewModels.firstIndex(where: { $0.criterion.id == criterion.id }) {
            criterionViewModels[index].criterion.progress = criterion.progress
        }

        isCompleted = skill.items.allSatisfy { $0.progress == 5 }
        
        service.updateProgress(for: criterion)
    }
}
