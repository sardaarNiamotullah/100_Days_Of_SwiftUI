//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sardaar Niamotullah on 22/3/26.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland",
        "Spain", "UK", "Ukraine", "US"
    ].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0

    @State private var questionNumber = 1
    let totalQuestions = 4

    @State private var showingFinalScore = false
    @State private var finalMessage = ""

    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(
                        color: Color(red: 0.1, green: 0.2, blue: 0.45),
                        location: 0.3
                    ),
                    .init(
                        color: Color(red: 0.76, green: 0.15, blue: 0.26),
                        location: 0.3
                    ),
                ],
                center: .top,
                startRadius: 200,
                endRadius: 400
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Text("Question: \(questionNumber) / \(totalQuestions)")
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.headline)

                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over", isPresented: $showingFinalScore) {
            Button("Restart", action: restartGame)
        } message: {
            Text(finalMessage)
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! \nThe currect answer is \(countries[correctAnswer])."
        }

        if questionNumber == totalQuestions {
            finalMessage = resultMessage()
            showingFinalScore = true
        } else {
            showingScore = true
        }
    }

    func askQuestion() {
        questionNumber += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func restartGame() {
        score = 0
        questionNumber = 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func resultMessage() -> String {
        switch score {
        case 4:
            return "Perfect! You got 4 out of 4."
        case 3:
            return "Great job! You got 3 out of 4."
        case 2:
            return "Nice try! You got 2 out of 4."
        case 1:
            return "You got 1 out of 4. Keep practicing!"
        default:
            return "You got 0 out of 4. Better luck next time!"
        }
    }
}

#Preview {
    ContentView()
}
