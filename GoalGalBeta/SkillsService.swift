//
//  SkillsService.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI

class SkillsService: ObservableObject {
    @Published var skills: [Skill] = []
    
    init() {
        
    }
    
    func fetchSkills() {
        skills = load() ?? []
        print("fetch \(skills)")
    }

    func edit(_ skill: Skill) {
        skills = skills.map { $0.id == skill.id ? skill : $0 }
        save()
    }
        
    func delete(_ skill: Skill) {
        skills.removeAll { $0.id == skill.id }
        save()
    }
    
    private func save() {
        let encoder = JSONEncoder()
        guard let guestsData = try? encoder.encode(skills) else {
            fatalError("Unable to encode favourite IDs")
        }
        
        guard let path = Bundle.main.path(forResource: "SkillsJSON", ofType: "json") else {
            print("Can't find path")
            return
        }
        
        guard let _ = try? guestsData.write(to: URL(filePath: path)) else {
            fatalError("Unable to write array data to url: \(path)")
        }
    }
    
    private func load() -> [Skill]? {
        guard let path = Bundle.main.path(forResource: "SkillsJSON", ofType: "json") else {
            print("Can't find path")
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(filePath: path)) else {
            return []
        }
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode([Skill].self, from: data) else {
            fatalError("Unable to decode data")
        }
        
        let skills = decodedData
        return skills
    }
}

