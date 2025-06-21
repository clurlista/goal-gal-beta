//
//  SkillDetailViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 20/06/2025.
//
import SwiftUI
import Combine

class SkillDetailViewModel: ObservableObject, Identifiable {
    @Published private(set) var skill: Skill
    @Published var isCompleted: Bool

    private let service: SkillsService
    private var cancellables = Set<AnyCancellable>()

    let id: String
    
    @MainActor
    var checkPointViewModels: [CheckPointViewModel] {
        skill.items.map { criteria in
            CheckPointViewModel(criteria: criteria, skillViewModel: self)
        }
    }

    init(skill: Skill, service: SkillsService) {
        self.skill = skill
        self.service = service
        self.id = skill.id
        self.isCompleted = skill.isCompleted
        observeSkillChanges()
    }
    
    func updateFromService() {
        if let updated = service.skills.first(where: { $0.id == skill.id }) {
            self.skill = updated
            self.isCompleted = updated.isCompleted
        }
    }

    private func observeSkillChanges() {
        service.$skills
            .map { $0.first(where: { $0.id == self.skill.id }) }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedSkill in
                guard let self = self else { return }
                self.skill = updatedSkill
                self.isCompleted = updatedSkill.isCompleted
            }
            .store(in: &cancellables)
    }

    func toggleCriteria(_ criteria: SkillCriteria) {
        var updatedCriteria = criteria
        updatedCriteria.isCompleted.toggle()
        service.updateProgress(for: skill, criteria: updatedCriteria)
    }
}
