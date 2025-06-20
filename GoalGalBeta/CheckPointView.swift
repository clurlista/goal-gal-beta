//
//  CheckPointView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI

struct CheckPointView: View {
    @ObservedObject var viewModel: SkillCriteriaViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.criterion.name)
                    .font(.headline)

                Spacer()

                Text("\(viewModel.criterion.progress)/5")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            HStack {
                Button(action: {
                    viewModel.decrementProgress()
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                }

                ProgressView(value: Double(viewModel.criterion.progress), total: 5)
                    .frame(maxWidth: .infinity)
                    .tint(.purple)

                Button(action: {
                    viewModel.incrementProgress()
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

