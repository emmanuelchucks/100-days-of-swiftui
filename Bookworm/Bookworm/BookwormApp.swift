//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Emmanuel Chucks on 08/12/2021.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
