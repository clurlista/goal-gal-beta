//
//  HomeViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var skills: [Skill] = []

    var fullyCompletedSkills: [Skill] {
        skills.filter { $0.isCompleted }
    }
    
    var incompleteSkills: [Skill] {
        skills.filter { !$0.isCompleted }
    }

    let service: SkillsService
    private var cancellables = Set<AnyCancellable>()

    init(service: SkillsService) {
        self.service = service
        observeSkills()
        service.fetchSkills()
    }

    private func observeSkills() {
        service.$skills
            .receive(on: DispatchQueue.main)
            .assign(to: \.skills, on: self)
            .store(in: &cancellables)
    }
}

