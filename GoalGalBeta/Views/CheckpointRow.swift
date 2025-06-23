//
//  CheckpointRow.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 21/06/2025.
//
import SwiftUI

struct CheckPointRow: View {
    let criteria: SkillCriteria
    let onToggle: () -> Void

    var body: some View {
        HStack {
            Text(criteria.name)
                .font(.custom("Menlo", size: 20))
            Spacer()
            Button(action: onToggle) {
                Image(systemName: criteria.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(criteria.isCompleted ? .green : .gray)
                    .imageScale(.large)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 4)
    }
}


