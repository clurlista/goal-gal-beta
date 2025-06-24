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
    
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    LoadingView()
                } else {
                    HomeView(service: service)
                }
            }
            .onAppear {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
        }
    }
}

