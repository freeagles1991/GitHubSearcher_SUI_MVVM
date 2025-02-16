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
    @State private var appModel = AppModel()
    
    var body: some Scene {
        let networkClient = NetworkClient()
        let repositoriesStorage = RepositoriesStorage()
        let dataLoader = DataLoader(
            networkClient: networkClient,
            repositoriesStorage: repositoriesStorage)
        
        WindowGroup {
            RepositoriesListView(
                repositoriesStorage: repositoriesStorage, dataLoader: dataLoader)
            .environment(appModel.dataStore)
            .modelContainer(appModel.modelContainer)
        }
    }
}
