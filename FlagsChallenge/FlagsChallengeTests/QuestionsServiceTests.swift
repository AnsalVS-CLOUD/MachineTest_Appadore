//
//  QuestionsServiceTests.swift
//  FlagsChallenge
//
//  Created by Harsh on 25/06/25.
//
import XCTest
@testable import FlagsChallenge

final class QuestionsServiceTests: XCTestCase {
    
    func testQuestionsLoadFromBundle() {
        let service = QuestionsService()
        let questions = service.getQuestions()
        
        XCTAssertFalse(questions.isEmpty, "Questions should not be empty if JSON is valid")
    }
}

