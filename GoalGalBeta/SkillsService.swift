//
//  SkillsService.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import Foundation
import SwiftUI

class SkillsService: ObservableObject {
    @Published var skills: [Skill] = []
    
    init(skills: [Skill] = []) {
        self.skills = skills
    }
    
    func fetchSkills() {
        if let savedSkills = load() {
            self.skills = savedSkills
        } else {
            self.skills = loadDefaultSkills()
            save()
        }
        
        print("✅ Loaded skills: \(skills.count)")
    }
    
    private func loadDefaultSkills() -> [Skill] {
        guard let url = Bundle.main.url(forResource: "SkillsJSON", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let skills = try? JSONDecoder().decode([Skill].self, from: data) else {
            print("❌ Failed to load default skills from bundle")
            return []
        }
        return skills
    }
    
    func edit(_ skill: Skill) {
        if let index = skills.firstIndex(where: { $0.id == skill.id }) {
            skills[index] = skill
            save()
        }
    }
    
    func delete(_ skill: Skill) {
        skills.removeAll { $0.id == skill.id }
        save()
    }
    
    func categoryCompleted(category: Skill) {
        print("Category \(category.name) completed!")
        // Any extra logic for completed categories here
    }
    
    func updateProgress(for skill: Skill, criteria updatedCriteria: SkillCriteria) {
        guard let skillIndex = skills.firstIndex(where: { $0.id == skill.id }) else { return }
        var updatedSkill = skills[skillIndex]
        
        if let criteriaIndex = updatedSkill.items.firstIndex(where: { $0.id == updatedCriteria.id }) {
            updatedSkill.items[criteriaIndex] = updatedCriteria
            skills[skillIndex] = updatedSkill  // Trigger @Published update
        }
    }
    
    // MARK: - Persistence
    
    private func save() {
        guard let data = try? JSONEncoder().encode(skills) else {
            print("❌ Failed to encode skills")
            return
        }
        
        do {
            try data.write(to: skillsFileURL(), options: .atomicWrite)
            print("✅ Skills saved")
        } catch {
            print("❌ Failed to save skills: \(error)")
        }
    }
    
    private func load() -> [Skill]? {
        do {
            let data = try Data(contentsOf: skillsFileURL())
            return try JSONDecoder().decode([Skill].self, from: data)
        } catch {
            print("❌ Failed to load skills: \(error)")
            return nil
        }
    }
    
    private func skillsFileURL() -> URL {
        let manager = FileManager.default
        let documents = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent("SkillsJSON.json")
    }
}



