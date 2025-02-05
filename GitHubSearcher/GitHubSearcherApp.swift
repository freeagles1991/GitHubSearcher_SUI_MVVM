//
//  GitHubSearcherApp.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import SwiftUI

@main
struct GitHubSearcherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
