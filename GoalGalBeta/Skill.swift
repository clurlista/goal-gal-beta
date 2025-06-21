//
//  Skill.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import Foundation

struct Skill: Codable, Identifiable {
    let name: String
    let id: Int
    let items: [String]
    var progress: Int

    // Custom initializer
    init(name: String, id: Int, items: [String], progress: Int = 0) {
        self.name = name
        self.id = id
        self.items = items
        self.progress = progress
    }

    // Init from decoder for custom handling (optional override)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.id = try container.decode(Int.self, forKey: .id)
        self.items = try container.decode([String].self, forKey: .items)
        self.progress = try container.decode(Int.self, forKey: .progress)
    }

    // Optional: Custom encoder (not required unless special formatting is needed)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(id, forKey: .id)
        try container.encode(items, forKey: .items)
        try container.encode(progress, forKey: .progress)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case id
        case items
        case progress
    }
}
