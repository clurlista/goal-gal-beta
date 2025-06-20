//
//  SkillCriteriaViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 20/06/2025.
//
import Foundation

class SkillCriteriaViewModel: ObservableObject, Identifiable {
    @Published var criterion: SkillCriteria

    var id: String { criterion.id }

    init(criterion: SkillCriteria) {
        self.criterion = criterion
    }

    func incrementProgress() {
        if criterion.progress < 5 {
            criterion.progress += 1
        }
    }

    func decrementProgress() {
        if criterion.progress > 0 {
            criterion.progress -= 1
        }
    }
}
