//
//  SkillsProgressView.swift
//  WomensFootballApp
//
//  Created by Claire Lister on 28/10/2024.
//
import SwiftUI

struct MasteredSkillView: View {
    var skill: Skill

    var body: some View {
        VStack(spacing: 12) {
            Text(skill.name.capitalized)
                .font(.custom("Digital Arcade Regular", size: 20))
                .foregroundColor(.purple)
                .multilineTextAlignment(.center)
                .padding([.top, .horizontal])

            Text("💪")
                .font(.largeTitle)

            Text("All skill criteria completed!")
                .font(.caption)
                .foregroundColor(.gray)

            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 40, maxHeight: 40)
                .foregroundColor(.green)
                .padding()
        }
        .padding()
        .frame(minWidth: 200, minHeight: 200)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.purple, lineWidth: 1)
        )
        .frame(maxWidth: .infinity)
    }
}
