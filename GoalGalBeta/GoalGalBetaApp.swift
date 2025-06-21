//
//  GoalGalBetaApp.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 18/06/2025.
//

import SwiftUI

@main
struct GoalGalApp: App {
    var body: some Scene {
        WindowGroup {
            SkillsListView(viewModel: SkillsListViewModel(SkillsService: SkillsService()))
        }
    }
}
