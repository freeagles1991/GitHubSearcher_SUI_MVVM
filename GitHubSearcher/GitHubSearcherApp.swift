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
    @StateObject private var appModel = AppModel()
    @StateObject private var flowController = FlowController()
    
    var body: some Scene {
        let networkClient = NetworkClient()
        let repositoriesStorage = RepositoriesStorage()
        let dataLoader = DataLoader(
            networkClient: networkClient,
            repositoriesStorage: repositoriesStorage)
        let repositoriesListVM = RepositoriesListViewModel(dataLoader: dataLoader, repositoriesStorage: repositoriesStorage, swiftDataStore: appModel.dataStore)
        
        WindowGroup {
            NavigationStack(path: $flowController.navigationPath) {
                RepositoriesListView(viewModel: repositoriesListVM)
                    .environmentObject(flowController)
                    .navigationDestination(for: FlowDestination.self) { destination in
                        switch destination {
                        case .repositoryDetail(let repository):
                            RepositoryDetailView(
                                dataLoader: repositoriesListVM.dataLoader,
                                swiftDataStore: repositoriesListVM.swiftDataStore,
                                repository: repository
                            )
                        }
                    }
            }
        }
    }
}
