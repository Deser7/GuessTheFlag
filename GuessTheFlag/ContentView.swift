//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Наташа Спиридонова on 06.07.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = [
        "Estonia",
        "France",
        "Germany",
        "Ireland",
        "Italy",
        "Monaco",
        "Nigeria",
        "Poland",
        "Russia",
        "Spain",
        "United Kingdom",
        "USA"
    ].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var isGameOver = false
    @State private var questionAsked = 0
    
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ],
                center: .top,
                startRadius: 200,
                endRadius: 700
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .titleStyle()
                
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
                            FlagImage(countryName: countries[number])
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
                    .titleStyle()
                
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is: \(score)")
        }
        
        .alert("Game over", isPresented: $isGameOver) {
            Button("Restart", action: restartGame)
        } message: {
            Text("There are \(score) correct answers out of \(questionAsked)")
        }
    }
    
    func flagTapped(_ number: Int) {
        scoreTitle = number == correctAnswer
        ? "Correct"
        : "Wrong! That's the flag of \(countries[number])"
        score += number == correctAnswer ? 1 : 0
        
        questionAsked += 1
        
        isGameOver = questionAsked == 8
        showingScore = !isGameOver
    
/*
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        
        questionAsked += 1
        
        if questionAsked == 8 {
            isGameOver = true
        } else {
            showingScore = true
        }
 */
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame() {
        score = 0
        questionAsked = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}

struct FlagImage: View {
    let countryName: String
    
    var body: some View {
        Image(countryName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}
