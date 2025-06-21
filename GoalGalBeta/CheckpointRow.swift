//
//  CheckpointRow.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 21/06/2025.
//
import SwiftUI

struct CheckPointRow: View {
    @ObservedObject var viewModel: CheckPointViewModel
    var onToggle: () -> Void  // Callback after toggle
    
    var body: some View {
        HStack {
            Text(viewModel.displayCheckPoint)
            Spacer()
            Button(action: {
                viewModel.toggleCompletion()
                onToggle()  // Notify parent view model to refresh data
            }) {
                Image(systemName: viewModel.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(viewModel.isCompleted ? .green : .gray)
                    .imageScale(.large)
            }
            .buttonStyle(BorderlessButtonStyle()) // Important for List row buttons
        }
        .padding(.vertical, 4)
    }
}

