//
//  CountdownView.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 23/06/25.
//

import SwiftUI

struct CountdownView: View {
    @ObservedObject var viewModel: FlagsGameViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            Text("FLAGS CHALLENGE")
                .font(AppFonts.titleFont())
                .foregroundColor(AppColors.primaryText)
            
            Text("CHALLENGE\nWILL START IN")
                .font(AppFonts.headingFont())
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            if case .countdown(let remaining) = viewModel.timerState {
                Text(String(format: "00:%02d", remaining))
                    .font(AppFonts.countdownFont())
                    .foregroundColor(AppColors.primaryText)
            }
        }
    }
}
