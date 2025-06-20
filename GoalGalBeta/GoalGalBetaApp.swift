//
//  GoalGalBetaApp.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 18/06/2025.
//

import SwiftUI

@main
struct GoalGalBetaApp: App {
    private let service = SkillsService()
    var body: some Scene {
        WindowGroup {
            HomeView(service: service)
        }
    }
}
