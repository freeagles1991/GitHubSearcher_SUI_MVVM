//
//  GitHubSearcherApp.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import SwiftUI
import SwiftData

@main
struct GitHubSearcherApp: App {
    var body: some Scene {
        let networkClient = NetworkClient()
        let repositoriesStorage = RepositoriesStorage()
        let dataLoader = DataLoader(
            networkClient: networkClient,
            repositoriesStorage: repositoriesStorage)
        let swiftDataStore = SwiftDataStoreController()
        
        WindowGroup {
            RepositoriesListView(
                repositoriesStorage: repositoriesStorage,
                swiftDataStore: swiftDataStore, dataLoader: dataLoader)
        }
        .modelContainer(for: RepositoryEntity.self)
    }
}
