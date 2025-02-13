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

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
