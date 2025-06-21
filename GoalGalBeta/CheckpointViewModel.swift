//
//  CheckpointViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 21/06/2025.
//
import Foundation

@MainActor
class CheckPointViewModel: ObservableObject, Identifiable {
    @Published var criteria: SkillCriteria
    private let parentViewModel: SkillDetailViewModel

    var id: String { criteria.id }

    var displayCheckPoint: String {
        criteria.name
    }

    var isCompleted: Bool {
        criteria.isCompleted
    }

    init(criteria: SkillCriteria, skillViewModel: SkillDetailViewModel) {
        self.criteria = criteria
        self.parentViewModel = skillViewModel
    }

    func toggleCompletion() {
        parentViewModel.toggleCriteria(criteria)
    }
}

