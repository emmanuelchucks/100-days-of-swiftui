//
//  Card.swift
//  Flashzilla
//
//  Created by Emmanuel Chucks on 13/04/2022.
//

import Foundation

struct Card: Codable, Equatable, Identifiable {
    var id = UUID()
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "What is God's personal name?", answer: "Yahweh")
}

class Cards: ObservableObject {
    @Published private(set) var all: [Card] = []
    @Published var newPrompt = ""
    @Published var newAnswer = ""
    
    var documentUrl: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = paths[0].appendingPathComponent("SavedData.json")
        return url
    }
    
    init() {
        load()
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(all) {
            try? encoded.write(to: documentUrl)
        }
    }
    
    func load() {
        if let data = try? Data(contentsOf: documentUrl) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                all = decoded
            }
        }
    }
    
    func add() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedPrompt.isEmpty && !trimmedAnswer.isEmpty else { return }
        
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        all.insert(card, at: 0)
        save()
        
        newPrompt = ""
        newAnswer = ""
    }
    
    func remove(at offsets: IndexSet) {
        all.remove(atOffsets: offsets)
        save()
    }
}
