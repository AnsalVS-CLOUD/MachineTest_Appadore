//
//  GameModels.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 23/06/25.
//

import Foundation
import SwiftUI
import CoreData

// MARK: - Basic Models
struct Question: Codable, Identifiable {
    let id = UUID()
    let answerId: Int
    let countries: [Country]
    let countryCode: String
    
    var correctAnswer: Country? {
        return countries.first { $0.id == answerId }
    }
    
    var flagImageName: String {
        return countryCode.lowercased()
    }
    
    private enum CodingKeys: String, CodingKey {
        case answerId = "answer_id"
        case countries
        case countryCode = "country_code"
    }
}

struct Country: Codable, Identifiable, Equatable {
    let id: Int
    let countryName: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case countryName = "country_name"
    }
}

struct QuestionsResponse: Codable {
    let questions: [Question]
}

struct UserAnswer: Identifiable, Codable {
    var id = UUID()
    let questionId: UUID
    let selectedCountryId: Int?
    let isCorrect: Bool
    let timeRemaining: Int
    let timestamp: Date
}

struct GameSession: Identifiable, Codable {
    let id: UUID
    let scheduledTime: Date
    var startTime: Date?
    var currentQuestionIndex: Int
    var answers: [UserAnswer]
    var gameState: GameState
    var backgroundTime: Date?
    let questions: [Question]
    
    var score: Int {
        return answers.filter { $0.isCorrect }.count
    }
    
    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    // custom init to provide default id
    init(
        id: UUID = UUID(),
        scheduledTime: Date,
        startTime: Date? = nil,
        currentQuestionIndex: Int,
        answers: [UserAnswer],
        gameState: GameState,
        backgroundTime: Date? = nil,
        questions: [Question]
    ) {
        self.id = id
        self.scheduledTime = scheduledTime
        self.startTime = startTime
        self.currentQuestionIndex = currentQuestionIndex
        self.answers = answers
        self.gameState = gameState
        self.backgroundTime = backgroundTime
        self.questions = questions
    }
}


// MARK: - Enums
enum GameState: String, CaseIterable, Codable {
    case notStarted = "not_started"
    case scheduled = "scheduled"
    case countdown = "countdown"
    case inProgress = "in_progress"
    case questionInterval = "question_interval"
    case showingAnswer = "showing_answer"
    case gameOver = "game_over"
}

enum TimerState {
    case countdown(remaining: Int)
    case question(remaining: Int)
    case interval(remaining: Int)
    case stopped
}

struct GameConfig {
    static let countdownDuration: TimeInterval = 20
    static let questionDuration: TimeInterval = 30
    static let intervalDuration: TimeInterval = 10
    static let totalQuestions: Int = 15
}

