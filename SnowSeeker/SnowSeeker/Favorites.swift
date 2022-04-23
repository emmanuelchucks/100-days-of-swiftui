//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Emmanuel Chucks on 23/04/2022.
//

import Foundation

class Favorites: ObservableObject {
    @Published private(set) var resorts: Set<String>
    private let saveKey = "Favorites"
    
    init() {
        if let savedFavorites = UserDefaults.standard.data(forKey: saveKey) {
            if let favorites = try? JSONDecoder().decode(Set<String>.self, from: savedFavorites) {
                resorts = favorites
                return
            }
        }
        
        resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    
}
