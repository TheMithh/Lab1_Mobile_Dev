//
//  ContentView.swift
//  Lab1_Gabriel_Pais
//
//  Created by viorel pais on 2025-02-13.
//

import SwiftUI

struct ContentView: View {
    @State private var currentNumber = 0  // No number displayed initially
    @State private var gameStarted = false
    @State private var showResult = false
    @State private var isCorrect = false
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attempts = 0
    @State private var timer: Timer?
    @State private var showScoreAlert = false
    @State private var lastCorrectCount: Int? = nil
    @State private var lastWrongCount: Int? = nil
    @State private var gameOver = false

    let maxAttempts = 10  // Maximum number of tries per game

    var body: some View {
        VStack(spacing: 20) {
            // Show Last Attempt Results ONLY when the game has NOT started
            if !gameStarted {
                if let lastCorrect = lastCorrectCount, let lastWrong = lastWrongCount {
                    VStack {
                        Text("Last Attempt Results")
                            .font(.headline)
                            .padding(.top)

                        HStack {
                            Text("✅ Correct: \(lastCorrect)")
                                .foregroundColor(.green)
                            Spacer()
                            Text("❌ Wrong: \(lastWrong)")
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                } else {
                    Text("No Previous Attempts")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                }
            }

            // Show "Start" button if game has NOT started or if game over
            if !gameStarted || gameOver {
                Button(action: startGame) {
                    Text(gameOver ? "Restart Game" : "Start Game")
                        .font(.title)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            } else {
                // Once game has started, show game UI
                Text("Is \(currentNumber) a prime number?")
                    .font(.largeTitle)
                    .padding()

                HStack {
                    Button(action: { checkAnswer(isPrime: true, timeExpired: false) }) {
                        Text("Prime")
                            .font(.title)
                            .frame(width: 120, height: 50)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    Button(action: { checkAnswer(isPrime: false, timeExpired: false) }) {
                        Text("Not Prime")
                            .font(.title)
                            .frame(width: 120, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }

                if showResult {
                    Image(systemName: isCorrect ? "checkmark.circle" : "xmark.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(isCorrect ? .green : .red)
                        .transition(.scale)
                }
                
                Text("Attempts: \(attempts)/\(maxAttempts)")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
        .alert("Game Over", isPresented: $showScoreAlert, actions: {
            Button("OK") {
                lastCorrectCount = correctCount
                lastWrongCount = wrongCount
                resetGame()
            }
        }, message: {
            Text("✅ Correct: \(correctCount)\n❌ Wrong: \(wrongCount)")
        })
    }

    // Start game when user presses "Start Game" button
    func startGame() {
        gameStarted = true
        gameOver = false
        correctCount = 0
        wrongCount = 0
        attempts = 0
        nextNumber()
        startTimer()
    }

    func checkAnswer(isPrime: Bool, timeExpired: Bool) {
        stopTimer()
        
        if timeExpired {
            // If the user does NOT select in time, it's always counted as incorrect
            isCorrect = false
            wrongCount += 1
        } else {
            // Normal answer checking
            let correctAnswer = self.isPrime(currentNumber)
            isCorrect = (isPrime == correctAnswer)
            if isCorrect {
                correctCount += 1
            } else {
                wrongCount += 1
            }
        }

        showResult = true
        attempts += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            showResult = false
            if attempts >= maxAttempts {
                endGame()
            } else {
                nextNumber()
            }
        }
    }

    func nextNumber() {
        currentNumber = Int.random(in: 1...100)
        startTimer()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            checkAnswer(isPrime: false, timeExpired: true) // Ensures timeout is always incorrect
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func endGame() {
        gameOver = true
        gameStarted = false
        showScoreAlert = true
    }

    func resetGame() {
        gameStarted = false
        gameOver = false
        currentNumber = 0  // Reset to blank before next start
    }

    func isPrime(_ number: Int) -> Bool {
        guard number > 1 else { return false }
        if number <= 3 { return true }
        for i in 2...Int(sqrt(Double(number))) {
            if number % i == 0 {
                return false
            }
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}