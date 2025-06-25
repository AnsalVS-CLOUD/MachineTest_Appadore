//
//  FlagsGameViewModel.swift
//  FlagsChallenge
//
//  Created by Ansal V S on 23/06/25.
//
import Foundation
import SwiftUI
import Combine

@MainActor
class FlagsGameViewModel: ObservableObject {
    @Published var selectedHour: Int = 0
    @Published var selectedMinute: Int = 1
    @Published var selectedSecond: Int = 0
    @Published var gameSession: GameSession?
    @Published var timerState: TimerState = .stopped
    @Published var scheduledTime: Date = Date().addingTimeInterval(60)
    @Published var selectedAnswer: Country?
    @Published var showingCorrectAnswer: Bool = false
    @Published var timeString: String = "00:00"
    
    private var gameTimer: Timer?
    private let questionsService = QuestionsService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupNotifications()
        loadSavedSessionIfNeeded()
    }
    
    func scheduleGame() {
        let now = Date()
        if let scheduled = Calendar.current.date(byAdding: .hour, value: selectedHour, to: now),
           let withMinutes = Calendar.current.date(byAdding: .minute, value: selectedMinute, to: scheduled),
           let withSeconds = Calendar.current.date(byAdding: .second, value: selectedSecond, to: withMinutes) {
            scheduledTime = withSeconds
        }
        
        let questions = questionsService.getQuestions()
        gameSession = GameSession(
            scheduledTime: scheduledTime,
            startTime: nil,
            currentQuestionIndex: 0,
            answers: [],
            gameState: .scheduled,
            questions: questions
        )
        startScheduleTimer()
    }
    
    private func startScheduleTimer() {
        gameTimer?.invalidate()
        gameTimer = TimerUtility.createRepeatingTimer(interval: 1.0) {
            self.updateScheduleTimer()
        }
    }
    
    private func updateScheduleTimer() {
        guard let session = gameSession else { return }
        
        let timeUntilStart = session.scheduledTime.timeIntervalSinceNow
        
        if timeUntilStart <= GameConfig.countdownDuration {
            startCountdown()
        } else {
            updateTimeString(timeUntilStart)
        }
    }
    
    private func startCountdown() {
        guard case .countdown = timerState else {
            gameSession?.gameState = .countdown
            gameTimer?.invalidate()
            
            var remaining = Int(GameConfig.countdownDuration)
            
            DispatchQueue.main.async {
                self.timerState = .countdown(remaining: remaining)
                self.timeString = TimeFormatterUtil.formatSeconds(seconds: remaining)
            }
            
            gameTimer = TimerUtility.createRepeatingTimer(interval: 1.0) {
                remaining -= 1
                DispatchQueue.main.async {
                    self.timerState = .countdown(remaining: remaining)
                    self.timeString = TimeFormatterUtil.formatSeconds(seconds: remaining)
                    
                    if remaining <= 0 {
                        self.gameTimer?.invalidate()
                        self.startGame()
                    }
                }
            }
            
            return
        }
    }
    
    private func startGame() {
        gameSession?.gameState = .inProgress
        showNextQuestion()
    }
    
    private func showNextQuestion() {
        guard let session = gameSession,
              session.currentQuestionIndex < session.questions.count else {
            endGame()
            return
        }
        
        selectedAnswer = nil
        showingCorrectAnswer = false
        startQuestionTimer()
    }
    
    private func startQuestionTimer(from remaining: Int? = nil) {
        var timeRemaining = remaining ?? Int(GameConfig.questionDuration)
        timerState = .question(remaining: timeRemaining)
        
        gameTimer?.invalidate()
        gameTimer = TimerUtility.createRepeatingTimer(interval: 1.0) {
            timeRemaining -= 1
            DispatchQueue.main.async {
                self.timerState = .question(remaining: timeRemaining)
                self.timeString = TimeFormatterUtil.formatSeconds(seconds: timeRemaining)
                if timeRemaining <= 0 {
                    self.timeUpForQuestion()
                }
            }
        }
    }

    func selectAnswer(_ country: Country) {
        selectedAnswer = country
    }
    
    private func timeUpForQuestion() {
        gameTimer?.invalidate()
        processAnswer(timeRemaining: 0)
    }
    
    private func processAnswer(timeRemaining: Int) {
        guard let session = gameSession,
              let currentQuestion = session.currentQuestion else { return }
        
        let isCorrect = selectedAnswer?.id == currentQuestion.answerId
        
        let userAnswer = UserAnswer(
            questionId: currentQuestion.id,
            selectedCountryId: selectedAnswer?.id,
            isCorrect: isCorrect,
            timeRemaining: timeRemaining,
            timestamp: Date()
        )
        
        gameSession?.answers.append(userAnswer)
        showingCorrectAnswer = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.nextQuestion()
        }
    }
    
    private func nextQuestion() {
        gameSession?.currentQuestionIndex += 1
        showNextQuestion()
    }
    
    private func endGame() {
        gameTimer?.invalidate()
        gameSession?.gameState = .gameOver
        timerState = .stopped
    }
    
    private func updateTimeString(_ interval: TimeInterval) {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        timeString = TimeFormatterUtil.formatTime(minutes: minutes, seconds: seconds)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                self?.saveBackgroundTime()
            }
            .store(in: &cancellables)

    }
    private func saveBackgroundTime() {
        guard var session = gameSession else { return }
        session.backgroundTime = Date()
        CoreDataManager.shared.saveSession(session)
    }
    
    func loadSavedSessionIfNeeded() {
        guard var savedSession = CoreDataManager.shared.loadSession() else { return }
        
        let now = Date()
        
        if savedSession.gameState == GameState.inProgress,
           let startTime = savedSession.startTime {
            
            let elapsed = now.timeIntervalSince(startTime)
            let questionDuration = GameConfig.questionDuration
            let totalElapsed = Int(elapsed)
            
            let currentQuestion = totalElapsed / Int(questionDuration)
            let questionTimePassed = totalElapsed % Int(questionDuration)
            let questionTimeRemaining = Int(questionDuration) - questionTimePassed
            
            if currentQuestion >= savedSession.questions.count {
                endGame()
                return
            }
            
            savedSession.currentQuestionIndex = currentQuestion
            gameSession = savedSession
            
            showNextQuestion()
            startQuestionTimer(from: questionTimeRemaining)
            
        } else if savedSession.gameState == GameState.scheduled {
            scheduledTime = savedSession.scheduledTime
            gameSession = savedSession
            startScheduleTimer()
        }
    }

}
extension FlagsGameViewModel {
    /// Resets the game back to the initial schedule screen
    func resetGame() {
        gameTimer?.invalidate()
        gameSession = nil
        timerState = .stopped
        timeString = "00:00"
        selectedAnswer = nil
        showingCorrectAnswer = false
        // reset pickers :
        selectedHour = 0
        selectedMinute = 1
        selectedSecond = 0
    }
    
}
