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

    @Published var favoriteIconName: String
    @Published var userEmail: String?
    
    enum Constants {
        enum Texts: String {
            case loadingText = "Loading..."
            case loadingErrorText = "Loading error"
            case noneText = "None"
        }
        
        enum ImageNames: String {
            case addFavoriteIcon = "star"
            case deleteFavoriteIcon = "star.fill"
        }
    }

    init(repository: Repository, dataLoader: DataLoaderProtocol, swiftDataStore: SwiftDataStoreController) {
        self.repository = repository
        self.dataLoader = dataLoader
        self.swiftDataStore = swiftDataStore
        self.favoriteIconName = Constants.ImageNames.addFavoriteIcon.rawValue
        if !isFavoriteRepository() {
            userEmail = Constants.Texts.loadingText.rawValue
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
                        self?.userEmail = Constants.Texts.noneText.rawValue
                    }
                    
                }
            case .failure(let error):
                print("Email loading error - \(error)")
                self?.userEmail = Constants.Texts.loadingErrorText.rawValue
            }
        }
    }

    func handleFavoriteButtonTap() {
        if !swiftDataStore.repositoryExists(repository) {
            let newRepo = Repository(id: repository.id, fullName: repository.fullName, owner: repository.owner, description: repository.description, ownerEmail: userEmail ?? Constants.Texts.noneText.rawValue)
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
        favoriteIconName = swiftDataStore.repositoryExists(repository) ? Constants.ImageNames.deleteFavoriteIcon.rawValue : Constants.ImageNames.addFavoriteIcon.rawValue
    }
}
