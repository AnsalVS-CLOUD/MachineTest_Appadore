//
//  GameView.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 23/06/25.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: FlagsGameViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let session = viewModel.gameSession,
               let question = session.currentQuestion {
                
                HStack {
                    Text("\(session.currentQuestionIndex + 1)")
                        .font(AppFonts.bodyFont())
                        .foregroundColor(AppColors.primaryText)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Text("GUESS THE COUNTRY BY THE FLAG!")
                    .font(AppFonts.bodyFont())
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Image(question.countryCode)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 80)
                    .cornerRadius(8)
                
                VStack(spacing: 15) {
                    // contains duplicate Country IDs(id == 235)
                    //without fixing JSON , using a unique key like UUID() inside the ForEach
                    ForEach(Array(question.countries.enumerated()), id: \.offset) { index, country in
                        OptionButton(
                            country: country,
                            isSelected: viewModel.selectedAnswer?.id == country.id,
                            isCorrect: viewModel.showingCorrectAnswer && country.id == question.answerId,
                            isWrong: viewModel.showingCorrectAnswer &&
                            viewModel.selectedAnswer?.id == country.id &&
                            country.id != question.answerId,
                            showingAnswer: viewModel.showingCorrectAnswer
                        ) {
                            viewModel.selectAnswer(country)
                        }
                    }

                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct OptionButton: View {
    let country: Country
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let showingAnswer: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 5) {
            Button(action: action) {
                HStack {
                    Text(country.countryName)
                        .foregroundColor(AppColors.primaryText)
                        .font(AppFonts.bodyFont())
                    Spacer()
                }
                .padding()
                .background(backgroundColor)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 2)
                )
            }
            .disabled(showingAnswer)
            
            if showingAnswer {
                if isCorrect {
                    Text("Correct")
                        .font(AppFonts.captionFont())
                        .foregroundColor(.green)
                } else if isWrong {
                    Text("Wrong")
                        .font(AppFonts.captionFont())
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private var backgroundColor: Color {
        if showingAnswer {
            if isCorrect { return Color.green.opacity(0.3) }
            if isWrong { return Color.red.opacity(0.3) }
        }
        return isSelected ? Color.orange.opacity(0.3) : AppColors.backgroundOption
    }
    
    private var borderColor: Color {
        if showingAnswer {
            if isCorrect { return Color.green }
            if isWrong { return Color.red }
        }
        return isSelected ? Color.orange : Color.gray
    }
}
