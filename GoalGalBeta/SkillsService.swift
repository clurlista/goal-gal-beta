//
//  SkillsService.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//

import Foundation
import Combine

class SkillsService: ObservableObject {
    @Published private(set) var categories: [Skill] = []
    let skillSubject = CurrentValueSubject<[Skill], Never>([])
    let skillCompletedSubject = PassthroughSubject<Skill, Never>()
    
    init() {
        copySocialisationJSONIfNecessary()
        Task {
            await loadCategories()
        }
    }
    
    var skillsFileURL: URL {
        getDocumentsDirectoryUrl().appending(path: "SkillsJSON.json")
    }
    
    private func copySocialisationJSONIfNecessary() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: skillsFileURL.path) {
            guard let jsonFileURL = Bundle.main.url(forResource: "SkillsJSON", withExtension: "json") else {
                print("❌ Unable to find JSON in bundle")
                return
            }
            do {
                try fileManager.copyItem(at: jsonFileURL, to: skillsFileURL)
                print("✅ Copied fresh SkillsJSON.json from bundle")
            } catch {
                print("❌ Unable to copy file: \(error)")
            }
        } else {
            print("🛑 SkillsJSON.json already exists, not overwriting")
        }
    }

    
    func loadCategories() async {
        guard let jsonData = try? Data(contentsOf: skillsFileURL) else {
            print("❌ Unable to create json from \(skillsFileURL)")
            return
        }

        // 🧪 Debug: Print the loaded JSON string
        if let string = String(data: jsonData, encoding: .utf8) {
            print("🚨 Loaded JSON:\n\(string)")
        }

        do {
            let loadedCategories = try JSONDecoder().decode([Skill].self, from: jsonData)
            DispatchQueue.main.async {
                self.categories = loadedCategories
                self.skillSubject.send(loadedCategories)
            }
        } catch {
            print("❌ Error decoding categories: \(error)")
        }
    }
    
    func updateProgress(for checkPoint: SkillCriteria) {
        var updatedCategories = categories
        guard let categoryIndex = updatedCategories.firstIndex(where: { category in
            category.items.contains(where: { $0.name == checkPoint.name })
        }) else { return }
        
        updatedCategories[categoryIndex].update(checkPoint: checkPoint)
        
        // Update both the published property and subject
        categories = updatedCategories
        skillSubject.send(updatedCategories)
        
        // Save the updated categories
        save(categories: updatedCategories)
    }
    
    func updateSkillProgress(for skillName: String, progress: Int) {
        guard let index = categories.firstIndex(where: { $0.name == skillName }) else { return }
        
        categories[index].progress = progress
        skillSubject.send(categories)
        
        save(categories: categories)
    }
    
    func save(categories: [Skill]) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            let categoriesData = try jsonEncoder.encode(categories)
            try categoriesData.write(to: self.skillsFileURL)
        } catch {
            print("Error saving categories: \(error)")
        }
    }
    
    func delete(categories: [Skill]) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            let categoriesData = try jsonEncoder.encode(categories)
            try categoriesData.write(to: self.skillsFileURL)
        } catch {
            print("Error saving categories: \(error)")
        }
    }
    
    func getDocumentsDirectoryUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Publisher for categories
    var categoriesPublisher: AnyPublisher<[Skill], Never> {
        skillSubject.eraseToAnyPublisher()
    }
    
    var categoryCompletedPublisher: AnyPublisher<Skill, Never> {
        skillCompletedSubject.eraseToAnyPublisher()
    }
    
    func categoryCompleted(category: Skill) {
        skillCompletedSubject.send(category)
    }
}
