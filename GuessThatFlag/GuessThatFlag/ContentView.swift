//
//  ContentView.swift
//  GuessThatFlag
//
//  Created by Emmanuel Chucks on 23/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var gameCount = 0
    @State private var alertAction = "Continue"
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
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
                                Image(countries[number])
                                    .renderingMode(.original)
                                    .cornerRadius(8)
                                    .shadow(radius: 4)
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
                if gameCount == 8 {
                    gameCount = 0   
                    score = 0
                }
                
                askQuestion()
            }
        } message: {
            Text(scoreMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        showingScore = true
        gameCount += 1
        
        if gameCount == 8 {
            score += 10
            scoreTitle = "Game Over!"
            scoreMessage = "Your total score is \(score)"
            alertAction = "Restart"
            
            return
        }
        
        if number == correctAnswer {
            score += 10
            scoreTitle = "Correct!"
            scoreMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong!"
            scoreMessage = "That's the flog of \(countries[number])"
        }
        
        
    }
    
    func askQuestion() {
        countries = countries.shuffled()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
