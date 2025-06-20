//
//  CheckPointViewViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI
import Combine

class CheckPointViewViewModel: ObservableObject, Identifiable {
    var id: String { checkPoint.id }
    private var checkPoint: SkillCriteria
    private let service: SkillsService

    @Published var isCompleted: Bool
    @Published private(set) var isCategoryCompleted: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    init(checkPoint: SkillCriteria, service: SkillsService) {
        self.checkPoint = checkPoint
        self.service = service
        self.isCompleted = checkPoint.isCompleted
        subscribe()
    }

    private func subscribe() {
        $isCompleted
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completed in
                guard let self = self else { return }

                self.checkPoint.isCompleted = completed
                self.service.updateProgress(for: self.checkPoint)

                self.service.skillSubject.send(self.service.categories)
            }
            .store(in: &cancellables)

        service.categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                guard let self = self else { return }

                for category in categories {
                    if let updated = category.items.first(where: { $0.name == self.checkPoint.name }) {
                        self.isCompleted = updated.isCompleted
                        self.isCategoryCompleted = category.items.allSatisfy { $0.isCompleted }
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }

    var displayCheckPoint: String {
        checkPoint.name.capitalized
    }

    func toggleCompletion() {
        checkPoint.isCompleted.toggle()
        isCompleted = checkPoint.isCompleted
        service.updateProgress(for: checkPoint)
    }
}
