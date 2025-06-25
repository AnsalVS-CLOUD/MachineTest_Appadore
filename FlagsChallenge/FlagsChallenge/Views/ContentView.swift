//
//  ContentView.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 23/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FlagsGameViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text(viewModel.timeString)
                            .font(AppFonts.bodyFont())
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.overlay)
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        if let session = viewModel.gameSession,
                           session.gameState == .inProgress {
                            Text("FLAGS CHALLENGE")
                                .font(AppFonts.bodyFont())
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    if let gameSession = viewModel.gameSession {
                        switch gameSession.gameState {
                        case .notStarted, .scheduled:
                            ScheduleView(viewModel: viewModel)
                        case .countdown:
                            CountdownView(viewModel: viewModel)
                        case .inProgress, .showingAnswer:
                            GameView(viewModel: viewModel)
                        case .gameOver:
                            GameOverView(viewModel: viewModel)
                        default:
                            ScheduleView(viewModel: viewModel)
                        }
                    } else {
                        ScheduleView(viewModel: viewModel)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
