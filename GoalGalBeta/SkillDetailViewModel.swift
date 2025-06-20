//
//  SkillDetailViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 20/06/2025.
//
import Foundation
import Combine

class SkillDetailViewModel: ObservableObject {
    @Published var checkPointViewModels: [CheckPointViewViewModel] = []
    @Published var isCompleted: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    let skill: Skill
    let service: SkillsService
    
    init(skill: Skill, service: SkillsService) {
        self.skill = skill
        self.service = service
        
        self.checkPointViewModels = skill.items.map { CheckPointViewViewModel(checkPoint: $0, service: service) }
        
        observeCompletion()
    }
    
    private func observeCompletion() {
      
        checkPointViewModels
            .publisher
            .flatMap { $0.$isCompleted }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isCompleted = self.checkPointViewModels.allSatisfy { $0.isCompleted }
            }
            .store(in: &cancellables)
    }
}
