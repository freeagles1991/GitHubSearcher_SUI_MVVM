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

@MainActor
class RepositoriesListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchStates: SearchStates = .empty
    @Published var repositories: [Repository] = []
    
    var dataLoader: DataLoaderProtocol
    var swiftDataStore: SwiftDataStoreController
    private var repositoriesStorage: RepositoriesStorage
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 1
    private let perPage: Int = 50
    private var isLoadingMore: Bool = false
    
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
                self?.searchRepositories(with: text, reset: true)
            }
            .store(in: &cancellables)
    }
    
    func searchRepositories(with searchText: String, reset: Bool = false) {
        if searchText.isEmpty {
            searchStates = .empty
            repositoriesStorage.clearStorage()
            return
        }
        
        if reset {
            searchStates = .loading
            repositories.removeAll()
            currentPage = 1
        }
        
        isLoadingMore = true
        
        let params: [String: String] = [
            "q" : searchText,
            "sort" : "stars",
            "per_page" : "\(perPage)",
            "page" : "\(currentPage)"
        ]
        
        dataLoader.fetchRepoData(with: params) { result in
            self.isLoadingMore = false
            switch result {
            case .success(let repos):
                self.repositories.append(contentsOf: repos)
                self.searchStates = .loaded
                self.currentPage += 1
            case .failure:
                self.searchStates = .error
            }
        }
    }
    
    func loadMoreRepositories() {
        if isLoadingMore {
            return
        }
    
        searchRepositories(with: searchText, reset: false)
    }
}
