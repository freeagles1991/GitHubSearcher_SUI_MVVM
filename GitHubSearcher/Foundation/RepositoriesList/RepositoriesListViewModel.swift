//
//  RepositoriesListViewModel.swift
//  GitHubSearcher
//
//  Created by Дима on 16.02.2025.
//

import SwiftUI
import Combine

enum SearchStates {
    case empty
    case loading
    case loaded
    case error
}

class RepositoriesListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchStates: SearchStates = .empty
    @Published var repositories: [Repository] = []
    @Published var favoriteRepositories: [Repository] = []
    
    var dataLoader: DataLoaderProtocol
    var swiftDataStore: SwiftDataStoreController
    private var repositoriesStorage: RepositoriesStorage
    private var cancellables = Set<AnyCancellable>()
    
    init(dataLoader: DataLoaderProtocol, repositoriesStorage: RepositoriesStorage, swiftDataStore: SwiftDataStoreController) {
        self.dataLoader = dataLoader
        self.repositoriesStorage = repositoriesStorage
        self.swiftDataStore = swiftDataStore
        bind()
    }
    
    func bind() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchRepositories(with: text)
            }
            .store(in: &cancellables)
    }
    
    func searchRepositories(with searchText: String) {
        if searchText.isEmpty {
            searchStates = .empty
            repositoriesStorage.clearStorage()
            return
        }
        
        searchStates = .loading
        
        let params: [String: String] = [
            "q" : searchText,
            "sort" : "stars",
            "per_page" : "100",
            "page" : "1"
        ]
        
        dataLoader.fetchRepoData(with: params) { result in
            switch result {
            case .success(let repos):
                self.repositories = repos
                self.searchStates = .loaded
            case .failure:
                self.searchStates = .error
            }
        }
    }
    
    @MainActor func toggleFavoriteTab(isActive: Bool) {
        if isActive {
            favoriteRepositories = swiftDataStore.favoriteRepositories
        }
    }
}
