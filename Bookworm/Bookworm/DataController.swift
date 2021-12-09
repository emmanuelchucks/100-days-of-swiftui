//
//  DataController.swift
//  Bookworm
//
//  Created by Emmanuel Chucks on 08/12/2021.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Core Data: \(error.localizedDescription)")
            }
        }
    }
}
