//
//  SkillDetailView.swift
//  GoalGalBeta
//
//  Created by Claire Lister on 20/06/2025.
//
import SwiftUI

struct SkillDetailView: View {
    @StateObject var viewModel: SkillDetailViewModel
    @State private var showConfetti = false
    @State private var wasCompleted = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(viewModel.skill.name.capitalized)
                    .font(.title)
                    .padding()

                List {
                    ForEach(viewModel.checkPointViewModels, id: \.id) { checkpointVM in
                        CheckPointRow(
                            viewModel: checkpointVM,
                            onToggle: {
                                if viewModel.isCompleted && !wasCompleted {
                                    triggerConfetti()
                                }
                                wasCompleted = viewModel.isCompleted
                            }
                        )
                    }
                }

                Text(viewModel.isCompleted ? "Completed 🎉" : "In Progress")
                    .font(.headline)
                    .foregroundColor(viewModel.isCompleted ? .green : .orange)
                    .padding()
            }

            if showConfetti {
                ConfettiView(count: 30)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .navigationTitle(viewModel.skill.name.capitalized)
        .onAppear {
            wasCompleted = viewModel.isCompleted
        }
        .onChange(of: viewModel.isCompleted) { newValue in
            if newValue && !wasCompleted {
                triggerConfetti()
            }
            wasCompleted = newValue
        }
    }

    private func triggerConfetti() {
        withAnimation {
            showConfetti = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showConfetti = false
            }
        }
    }
}
