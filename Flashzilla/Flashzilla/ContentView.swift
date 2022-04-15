//
//  ContentView.swift
//  Flashzilla
//
//  Created by Emmanuel Chucks on 17/03/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var model = Cards()
    
    @State private var cards = [Card]()
    @State private var timeRemaining = 90
    @State private var isActive = true
    @State private var showingEditScreen = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                
                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card) {
                            withAnimation {
                                removeCard(at: cards.firstIndex(of: card)!)
                            }
                        } addBack: {
                            addBackToStack(card)
                        }
                        .stacked(at: cards.firstIndex(of: card)!, in: cards.count)
                        .allowsHitTesting(cards.firstIndex(of: card)! == cards.count - 1)
                        .accessibilityHidden(cards.firstIndex(of: card)! < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: cards.isEmpty ? "plus.circle" : "pencil.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .accessibilityLabel(cards.isEmpty ? "Add" : "Edit")
                    .accessibilityHint(cards.isEmpty ? "Add a card" : "Edit your cards.")
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                
                Spacer()
            }
            
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer, perform: { time in
            guard isActive && !cards.isEmpty else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        })
        .onChange(of: scenePhase) { newPhase in
            isActive = !cards.isEmpty && newPhase == .active
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
    }
    
    func addBackToStack(_ card: Card) {
        cards.insert(card, at: 0)
    }
    
    func resetCards() {
        timeRemaining = 90
        isActive = true
        model.load()
        cards = model.all
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
