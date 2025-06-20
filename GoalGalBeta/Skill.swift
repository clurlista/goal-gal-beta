//
//  Skill.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import Foundation

struct Skill: Codable, Identifiable, Comparable {
    var id: String { name }
    var name: String
    var items: [SkillCriteria]
    var criteriaDescription: String

    // Computed property for progress as count of completed items
    var progress: Int {
        items.filter { $0.isCompleted }.count
    }

    // Computed property for completion status of the whole Skill
    var isCompleted: Bool {
        !items.isEmpty && items.allSatisfy { $0.isCompleted }
    }

    mutating func update(checkPoint: SkillCriteria) {
        if let index = items.firstIndex(where: { $0.id == checkPoint.id }) {
            items[index] = checkPoint
        }
    }

    static func == (lhs: Skill, rhs: Skill) -> Bool {
        lhs.name == rhs.name
    }
    
    static func < (lhs: Skill, rhs: Skill) -> Bool {
        lhs.name < rhs.name
    }
}

struct SkillCriteria: Codable, Identifiable, Hashable {
    let id: String  
    let name: String
    var isCompleted: Bool
}

