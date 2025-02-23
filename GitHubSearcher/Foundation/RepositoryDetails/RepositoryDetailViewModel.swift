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
    @Published var userEmail: String? = "Loading..."

    init(repository: Repository, dataLoader: DataLoaderProtocol, swiftDataStore: SwiftDataStoreController) {
        self.repository = repository
        self.dataLoader = dataLoader
        self.swiftDataStore = swiftDataStore
        if !isFavoriteRepository() {
            loadUserEmail(userName: repository.owner)
        }
        userEmail = repository.ownerEmail
        updateFavoriteIcon()
    }
    
    func isFavoriteRepository() -> Bool  {
        swiftDataStore.repositoryExists(repository)
    }

    func loadUserEmail(userName: String) {
        dataLoader.fetchUserData(with: userName) { [weak self] result in
            switch result {
            case .success(let userResponse):
                DispatchQueue.main.async {
                    if let email = userResponse.email {
                        self?.userEmail = email
                    } else {
                        self?.userEmail = "none"
                    }
                    
                }
            case .failure(let error):
                print("Email loading error - \(error)")
                self?.userEmail = "Loading error"
            }
        }
    }

    func handleFavoriteButtonTap() {
        if !swiftDataStore.repositoryExists(repository) {
            let newRepo = Repository(id: repository.id, fullName: repository.fullName, owner: repository.owner, description: repository.description, ownerEmail: userEmail ?? "none")
            self.repository = newRepo
            swiftDataStore.addRepository(newRepo) { result in
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
