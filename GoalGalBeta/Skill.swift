//
//  Skill.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import Foundation

struct Skill: Codable, Identifiable, Comparable {
    var id: String
    var name: String
    var items: [SkillCriteria]
    var criteriaDescription: String
    var progress: Int
    
    
    mutating func update(checkPoint: SkillCriteria) {
        guard let itemIndex = items.firstIndex(where: { $0.name == checkPoint.name }) else { return }
        items[itemIndex] = checkPoint
    }

    static func == (lhs: Skill, rhs: Skill) -> Bool {
        lhs.name == rhs.name
    }

    static func < (lhs: Skill, rhs: Skill) -> Bool {
        lhs.name < rhs.name
    }
}

struct SkillCriteria: Codable, Hashable, Identifiable {
    let name: String
    var progress: Int
    
    var id: String { name }

    init(name: String, progress: Int = 0) {
        self.name = name
        self.progress = min(max(progress, 0), 5)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: SkillCriteria, rhs: SkillCriteria) -> Bool {
        lhs.name == rhs.name
    }
}
