//
//  Prospect.swift
//  HotProspects
//
//  Created by Emmanuel Chucks on 12/03/2022.
//

import SwiftUI

class Prospect: Identifiable, Codable, Comparable, Equatable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    
    static func <(lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func ==(lhs: Prospect, rhs: Prospect) -> Bool {
        return lhs.id == rhs.id
    }
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect] = []
    var documentUrl: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = paths[0].appendingPathComponent("SavedData.json")
        return url
    }
    
    init() {
        if let data = try? Data(contentsOf: documentUrl) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
            }
        }
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: documentUrl)
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
