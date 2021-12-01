//
//  ContentView.swift
//  GuessThatFlag
//
//  Created by Emmanuel Chucks on 23/11/2021.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    
    @State private var score = 0
    @State private var gameCount = 0
    @State private var alertAction = ""
    
    var isLastRound: Bool { gameCount == 8 }
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var tappedFlag = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .opacity(0.8)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                
                VStack {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        Text(countries[correctAnswer])
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                            } label: {
                                FlagImage(country: countries[number])
                                    .rotation3DEffect(.degrees(showingScore && tappedFlag == countries[number] ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                    .opacity(showingScore && tappedFlag != countries[number] ? 0.25 : 1)
                                    .animation(.spring(), value: gameCount)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .cornerRadius(16)
                .padding()
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button(alertAction) {
                askQuestion()
            }
        } message: {
            Text(scoreMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        tappedFlag = countries[number]
        showingScore = true
        gameCount += 1
        
        if number == correctAnswer {
            score += 10
            scoreTitle = isLastRound ? "Game Over!" : "Correct!"
            scoreMessage = isLastRound ? "Your total score is \(score)" : "Your score is \(score)"
        } else {
            scoreTitle = isLastRound ? "Game Over!" : "Wrong!"
            scoreMessage = "That's the flog of \(countries[number])"
        }
        
        alertAction = isLastRound ? "Restart" : "Continue"
    }
    
    func askQuestion() {
        if isLastRound {
            gameCount = 0
            score = 0
        }
        
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
