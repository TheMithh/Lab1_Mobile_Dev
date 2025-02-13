//
//  ContentView.swift
//  Lab1_Gabriel_Pais
//
//  Created by viorel pais on 2025-02-13.
//

import SwiftUI

struct ContentView: View {
    @State private var currentNumber = 0
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
            Text("Prime Number Game")
                .font(.largeTitle)
                .fontWeight(.bold)
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
                    }
                } else {
                    Text("No Previous Attempts")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                }
            }

            if !gameStarted || gameOver {
                Button("Start Game", action: startGame)
            }

            // 🚀 Commit 6: Add question label
            if gameStarted {
                Text("Is \\(currentNumber) a prime number?")
                    .font(.title)
            }

            // 🚀 Commit 7: Add answer buttons
            HStack {
                Button("Prime") { checkAnswer(isPrime: true, timeExpired: false) }
                Button("Not Prime") { checkAnswer(isPrime: false, timeExpired: false) }
            }

            // 🚀 Commit 8: Add attempts counter
            Text("Attempts: \\(attempts)/\"\"\"\\(maxAttempts)\")")
                .font(.headline)

        }
    }

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
            isCorrect = false
            wrongCount += 1
        } else {
            isCorrect = isPrime == self.isPrime(currentNumber)
            if isCorrect { correctCount += 1 } else { wrongCount += 1 }
        }
        showResult = true
        attempts += 1
    }
    
    func nextNumber() {
        currentNumber = Int.random(in: 1...100)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            checkAnswer(isPrime: false, timeExpired: true)
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
        currentNumber = 0
    }

    func isPrime(_ number: Int) -> Bool {
        guard number > 1 else { return false }
        for i in 2..<Int(sqrt(Double(number))) + 1 {
            if number % i == 0 { return false }
        }
        return true
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

    .alert("Game Over", isPresented: $showScoreAlert) {
        Button("OK") { resetGame() }
    } message: {
        Text("✅ Correct: \\(correctCount)\n❌ Wrong: \\(wrongCount)")
    }

    if attempts >= maxAttempts {
        endGame()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
