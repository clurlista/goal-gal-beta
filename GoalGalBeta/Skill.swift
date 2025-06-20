//
//  Skill.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//

import Foundation

struct Skill: Codable, Hashable {
    let name: String
    var items: [SkillCriteria]
    
    mutating func update(checkPoint: SkillCriteria) {
        guard let itemIndex = items.firstIndex(where: { $0.name == checkPoint.name }) else { return }
        // Ensure progress stays within bounds
        let boundedProgress = min(max(checkPoint.progress, 0), 5)
        var updatedCheckPoint = checkPoint
        updatedCheckPoint.progress = boundedProgress
        items[itemIndex] = updatedCheckPoint
    }
}

struct SkillCriteria: Codable, Hashable {
    let name: String
    var progress: Int
    
    init(name: String, progress: Int = 0) {
        self.name = name
        self.progress = min(max(progress, 0), 5) // Ensure initial progress is within bounds
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: SkillCriteria, rhs: SkillCriteria) -> Bool {
        lhs.name == rhs.name
    }
}

extension Skill: Comparable {
    static func == (lhs: Skill, rhs: Skill) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Skill, rhs: Skill) -> Bool {
        return lhs.name < rhs.name
    }
}
