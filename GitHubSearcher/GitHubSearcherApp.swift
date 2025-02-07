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
        let networkClient = NetworkClient()
        let repositoriesStorage = RepositoriesStorage()
        let dataLoader = DataLoader(
            networkClient: networkClient,
            repositoriesStorage: repositoriesStorage)
        
        WindowGroup {
            RepositoriesListView(
                repositoriesStorage: repositoriesStorage,
                dataLoader: dataLoader)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
