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

    init(skill: Skill, service: SkillsService) {
        self.skill = skill
        self.service = service
        self.id = skill.id
        self.isCompleted = skill.isCompleted
        observeSkillChanges()
    }

    func toggleCriteria(_ criteria: SkillCriteria) {
        var updated = criteria
        updated.isCompleted.toggle()
        service.updateProgress(for: skill, criteria: updated)
    }

    private func observeSkillChanges() {
        service.$skills
            .compactMap { skills in
                skills.first(where: { $0.id == self.skill.id })
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedSkill in
                guard let self = self else { return }
                self.skill = updatedSkill
                self.isCompleted = updatedSkill.isCompleted
            }
            .store(in: &cancellables)
    }
}
