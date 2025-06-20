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
    private let skillCompletedSubject = PassthroughSubject<Skill, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        copySocialisationJSONIfNecessary()
        setupAutoSave()
        Task {
            await loadCategories()
        }
    }
    
    var skillsFileURL: URL {
        getDocumentsDirectoryUrl().appendingPathComponent("SkillsJSON.json")
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
    
    /// Update a single SkillCriteria's completion state inside categories
    func updateProgress(for checkPoint: SkillCriteria) {
        var updatedCategories = categories
        
        // Find the category that contains this checkpoint
        guard let categoryIndex = updatedCategories.firstIndex(where: { category in
            category.items.contains(where: { $0.id == checkPoint.id })
        }) else {
            print("⚠️ Checkpoint not found in any category")
            return
        }
        
        updatedCategories[categoryIndex].items = updatedCategories[categoryIndex].items.map { item in
            item.id == checkPoint.id ? checkPoint : item
        }
        
        categories = updatedCategories
        skillSubject.send(updatedCategories) // ✅ Auto-save will now handle saving

        let isCategoryCompleted = updatedCategories[categoryIndex].items.allSatisfy { $0.isCompleted }
        if isCategoryCompleted {
            categoryCompleted(category: updatedCategories[categoryIndex])
        }
    }
    
    /// Notify subscribers that a category is completed
    func categoryCompleted(category: Skill) {
        skillCompletedSubject.send(category)
    }
    
    private func setupAutoSave() {
        skillSubject
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] updated in
                self?.save(categories: updated)
            }
            .store(in: &cancellables)
    }
    
    /// Save current categories to disk
    func save(categories: [Skill]) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            let categoriesData = try jsonEncoder.encode(categories)
            try categoriesData.write(to: skillsFileURL)
            print("✅ Categories saved successfully")
        } catch {
            print("❌ Error saving categories: \(error)")
        }
    }
    
    /// Deletes categories (overwrites file with empty or partial categories)
    func delete(categories: [Skill]) {
        save(categories: categories)
    }
    
    func getDocumentsDirectoryUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Publisher for categories (read-only)
    var categoriesPublisher: AnyPublisher<[Skill], Never> {
        skillSubject.eraseToAnyPublisher()
    }
    
    // Publisher for category completion events
    var categoryCompletedPublisher: AnyPublisher<Skill, Never> {
        skillCompletedSubject.eraseToAnyPublisher()
    }
}

