//
//  RepositoryDetailViewModel.swift
//  GitHubSearcher
//
//  Created by Дима on 22.02.2025.
//

import Foundation

@MainActor
class RepositoryDetailViewModel: ObservableObject {
    private let dataLoader: DataLoaderProtocol
    private let swiftDataStore: SwiftDataStoreController
    private(set) var repository: Repository

    @Published var favoriteIconName: String = "star"
    @Published var userEmail: String?

    init(repository: Repository, dataLoader: DataLoaderProtocol, swiftDataStore: SwiftDataStoreController) {
        self.repository = repository
        self.dataLoader = dataLoader
        self.swiftDataStore = swiftDataStore
        loadUserEmail(userName: repository.owner)
        updateFavoriteIcon()
    }

    func loadUserEmail(userName: String) {
        dataLoader.fetchUserData(with: userName) { [weak self] result in
            switch result {
            case .success(let userResponse):
                DispatchQueue.main.async {
                    self?.userEmail = userResponse.email
                }
            case .failure(let error):
                print("Email loading error - \(error)")
            }
        }
    }

    func handleFavoriteButtonTap() {
        if !swiftDataStore.repositoryExists(repository) {
            swiftDataStore.addRepository(repository) { result in
                switch result {
                case .success():
                      self.updateFavoriteIcon()
                case .failure:
                    print("Failed to add repository")
                }
            }
        } else {
            swiftDataStore.deleteRepository(repository) { result in
                switch result {
                case .success():
                     self.updateFavoriteIcon()
                case .failure:
                    print("Failed to delete repository")
                }
            }
        }
    }

    
    @MainActor private func updateFavoriteIcon() {
        favoriteIconName = swiftDataStore.repositoryExists(repository) ? "star.fill" : "star"
    }
}
