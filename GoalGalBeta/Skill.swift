//
//  Skill.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI
import Combine

struct Skill: Codable, Identifiable, Comparable, Equatable, Hashable {
    let id: String
    var name: String
    var imageName: String
    var items: [SkillCriteria]
    var criteriaDescription: String

    var progress: Int {
        items.filter { $0.isCompleted }.count
    }

    var isCompleted: Bool {
        !items.isEmpty && items.allSatisfy { $0.isCompleted }
    }

    mutating func update(checkPoint: SkillCriteria) {
        if let index = items.firstIndex(where: { $0.id == checkPoint.id }) {
            items[index] = checkPoint
        }
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

