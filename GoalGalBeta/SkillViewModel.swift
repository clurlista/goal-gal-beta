//
//  SkillViewModel.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 21/06/2025.
//
import SwiftUI

class SkillViewModel {
    let service: SkillsService
    
    var skill: Skill
    var isSkillMastered: Bool = false
    
    init(service: SkillsService, skill: Skill) {
        self.service = service
        self.skill = skill
        
        isSkillMastered = skill.progress == 5
    }
    
    var steps: String {
        skill.items.map({
            $0
        }).joined(separator: ", ")
    }
    
    func increaseProgress() {
        if skill.progress < 5 {
            skill.progress += 1
            service.edit(skill)
        } else if skill.progress == 5 {
            isSkillMastered = true
        }
    }
    
    func decreaseProgress() {
        if skill.progress > 0 {
            skill.progress -= 1
            service.edit(skill)
        } else if skill.progress == 0 {
            isSkillMastered = false
        }
    }
}

