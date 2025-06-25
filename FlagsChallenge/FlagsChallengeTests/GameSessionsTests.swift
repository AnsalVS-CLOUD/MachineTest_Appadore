//
//  GameSessionsTests.swift
//  FlagsChallenge
//
//  Created by Harsh on 25/06/25.
//

import XCTest
@testable import FlagsChallenge  // <- This gives test access to your app code

final class GameSessionTests: XCTestCase {
    
    func testScoreCalculation() {
        let questionId = UUID()
        let answers = [
            UserAnswer(questionId: questionId, selectedCountryId: 1, isCorrect: true, timeRemaining: 10, timestamp: Date()),
            UserAnswer(questionId: questionId, selectedCountryId: 2, isCorrect: false, timeRemaining: 5, timestamp: Date()),
            UserAnswer(questionId: questionId, selectedCountryId: 3, isCorrect: true, timeRemaining: 3, timestamp: Date())
        ]
        
        let session = GameSession(
            scheduledTime: Date(),
            currentQuestionIndex: 0,
            answers: answers,
            gameState: .inProgress,
            questions: []
        )
        
        XCTAssertEqual(session.score, 2, "Score should be 2 because two answers are correct.")
    }
}
func testCurrentQuestion() {
    let mockQuestion = Question(answerId: 1, countries: [], countryCode: "IN")
    let session = GameSession(
        scheduledTime: Date(),
        currentQuestionIndex: 0,
        answers: [],
        gameState: .notStarted,
        questions: [mockQuestion]
    )
    XCTAssertNotNil(session.currentQuestion)
    XCTAssertEqual(session.currentQuestion?.countryCode, "IN")
}
