//
//  ScheduleView.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 23/06/25.
//
import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: FlagsGameViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("FLAGS CHALLENGE")
                .font(AppFonts.titleFont())
                .foregroundColor(AppColors.primaryText)
                
            
            Text("SCHEDULE")
                .font(AppFonts.headingFont())
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 20) {
                VStack {
                    Text("Hour")
                        .foregroundColor(AppColors.primaryText)
                    Picker("", selection: $viewModel.selectedHour) {
                        ForEach(0..<24) { Text("\($0)").tag($0) }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(8)
                }
                
                VStack {
                    Text("Minute")
                        .foregroundColor(AppColors.primaryText)
                    Picker("", selection: $viewModel.selectedMinute) {
                        ForEach(0..<60) { Text("\($0)").tag($0) }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(8)
                }
                
                VStack {
                    Text("Second")
                        .foregroundColor(AppColors.primaryText)
                    Picker("", selection: $viewModel.selectedSecond) {
                        ForEach(0..<60) { Text("\($0)").tag($0) }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .background(AppColors.secondaryBackground)
                    .cornerRadius(8)
                }
            }
            
            Button(action: {
                viewModel.scheduleGame()
            }) {
                Text("Save")
                    .font(AppFonts.buttonFont())
                    .foregroundColor(AppColors.buttonText)
                    .frame(width: 120, height: 50)
                    .background(AppColors.background)
                    .cornerRadius(25)
            }
        }
        .padding()
    }
}
