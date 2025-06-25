//
//  GameOverView.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 23/06/25.
//
import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: FlagsGameViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            Text("GAME OVER")
                .font(AppFonts.titleFont())
                .foregroundColor(AppColors.primaryText)
            
            if let session = viewModel.gameSession {
                Text("SCORE: \(session.score)/15")
                    .font(AppFonts.headingFont())
                    .foregroundColor(AppColors.accent)
            }
            
            Button(action: {
                viewModel.resetGame()
            }) {
                Text("Back to Schedule")
                    .font(AppFonts.buttonFont())
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.backgroundOption.cornerRadius(10))
            }
        }
        .padding()
    }
}

