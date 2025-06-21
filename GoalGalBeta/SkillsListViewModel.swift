//
//  SkillsListViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI
import Combine

class SkillsListViewModel: ObservableObject {
    @ObservedObject var skillsService: SkillsService
    
    @Published var skillsViewModels: [SkillViewModel] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(SkillsService: SkillsService) {
        self.skillsService = SkillsService
        
        skillsService.fetchSkills()
        subscribe()
    }
    
    func subscribe() {
        skillsService.$skills
            .receive(on: DispatchQueue.main)
            .sink { skills in
                // This creates the array of SkillViewModels which are then used in the list view to create the individual SkillViews.
                // It uses the skills that come from the publisher in the service to create a new array of viewModels every time the skills get updated in the backend.
                self.skillsViewModels = skills.map { SkillViewModel(service: self.skillsService, skill: $0)}
                print("ViewModels")
            }
            .store(in: &cancellables)
    }
}

