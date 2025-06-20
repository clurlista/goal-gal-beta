//
//  CheckPointViewViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//

import SwiftUI
import Combine

class CheckPointViewViewModel: ObservableObject {
    private var checkPoint: SkillCriteria
    private let service: SkillsService

    @Published var tickBoxViewModels: [TickBoxViewViewModel] = []
    @Published var progress: Int
    @Published private(set) var isCategoryCompleted: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    var isCompleted: Bool {
        progress == 5
    }
    
    init(checkPoint: SkillCriteria, service: SkillsService) {
        self.checkPoint = checkPoint
        self.service = service
        self.progress = checkPoint.progress

        createTickBoxes()
        subscribe()
    }

    private func subscribe() {
        // Subscribe to progress changes
        $progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newProgress in
                guard let self = self else { return }
                // Ensure progress stays within bounds
                let boundedProgress = min(max(newProgress, 0), 5)
                if boundedProgress != newProgress {
                    self.progress = boundedProgress
                    return
                }
                
                if self.checkPoint.progress != boundedProgress {
                    self.checkPoint.progress = boundedProgress
                    self.service.updateProgress(for: self.checkPoint)
                    
                    // Award 50 XP when checkpoint is completed
                    if boundedProgress == 5 {
                        // Update the total XP through the service's categories publisher
                        // This will trigger HomeViewModel's updateTotalXP method
                        self.service.skillSubject.send(self.service.categories)
                    }
                }
            }
            .store(in: &cancellables)
            
        // Subscribe to category updates to catch external changes
        service.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self = self else { return }
                
                // Find our checkpoint in the updated categories
                for category in categories {
                    if let updatedCheckPoint = category.items.first(where: { $0.name == self.checkPoint.name }) {
                        // Update local state if it differs
                        if updatedCheckPoint.progress != self.progress {
                            self.progress = updatedCheckPoint.progress
                            self.updateTickBoxes(for: updatedCheckPoint.progress)
                        }
                        
                        // Check if the category is completed
                        let isCategoryCompleted = category.items.allSatisfy { $0.progress == 5 }
                        if self.isCategoryCompleted != isCategoryCompleted {
                            self.isCategoryCompleted = isCategoryCompleted
                        }
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }

    var displayCheckPoint: String {
        checkPoint.name.capitalized
    }
    
    var checkPointProgress: Int {
        progress
    }
    
    func updateProgress() {
        let completedCount = tickBoxViewModels.filter { $0.isComplete }.count
        if completedCount != progress {
            progress = completedCount
        }
    }
    
    func incrementProgress() {
        if progress < 5 {
            progress += 1
            updateTickBoxes(for: progress)
        }
    }
    
    func decrementProgress() {
        if progress > 0 {
            progress -= 1
            updateTickBoxes(for: progress)
        }
    }

    private func updateTickBoxes(for progress: Int) {
        for (index, tickBox) in tickBoxViewModels.enumerated() {
            tickBox.isComplete = index < progress
        }
    }

    private func createTickBoxes() {
        // Create tickboxes based on current progress
        for i in 0..<5 {
            let isComplete = i < checkPoint.progress
            let tickBox = TickBoxViewViewModel(isComplete: isComplete) { [weak self] in
                self?.updateProgress()
            }
            tickBoxViewModels.append(tickBox)
        }
    }
}
