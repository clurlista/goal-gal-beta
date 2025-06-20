//
//  CheckPointView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 19/06/2025.
//
import SwiftUI

struct CheckPointView: View {
    @ObservedObject var viewModel: CheckPointViewViewModel

    var body: some View {
        HStack {
            Text(viewModel.displayCheckPoint)
            Spacer()
            Button(action: {
                withAnimation {
                    viewModel.toggleCompletion()
                }
            }) {
                Image(systemName: viewModel.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(viewModel.isCompleted ? .green : .gray)
                    .imageScale(.large)
                    .animation(.easeInOut, value: viewModel.isCompleted)
            }
        }
        .padding()
    }
}



