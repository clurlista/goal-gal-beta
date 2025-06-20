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

        criterionViewModels
            .publisher
            .flatMap { $0.$criterion }
            .map { _ in
                self.criterionViewModels.allSatisfy { $0.criterion.progress == 5 }
            }
            .receive(on: RunLoop.main)
            .assign(to: \.isCompleted, on: self)
            .store(in: &cancellables)

        criterionViewModels.forEach { vm in
            vm.$criterion
                .sink { [weak self] updated in
                    guard let self else { return }
                    if let index = self.skill.items.firstIndex(where: { $0.id == updated.id }) {
                        self.skill.items[index] = updated
                        self.service.updateProgress(for: updated)
                    }
                }
                .store(in: &cancellables)
        }
    }
}
