//
//  QuestionsService.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 23/06/25.
//

import Foundation

class QuestionsService: ObservableObject {
    func getQuestions() -> [Question] {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("Failed to locate questions.json in bundle.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(QuestionWrapper.self, from: data)
            return decoded.questions
        } catch {
            print("Failed to decode questions.json: \(error)")
            return []
        }
    }
}

struct QuestionWrapper: Codable {
    let questions: [Question]
}
