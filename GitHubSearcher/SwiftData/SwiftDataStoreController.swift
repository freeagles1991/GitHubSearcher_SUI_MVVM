//
//  SwiftDataStoreController.swift
//  GitHubSearcher
//
//  Created by Дима on 11.02.2025.
//

import SwiftUI
import SwiftData

final class SwiftDataStoreController: ObservableObject  {
    @Environment(\.modelContext) private var modelContext
    @Query private var favoriteRepositoriesSwiftData: [RepositoryEntity]
    @Published var favoriteRepositories: [Repository] = []
    
    func loadFavoriteRepositories() {
        self.favoriteRepositories = favoriteRepositoriesSwiftData.map { $0.toRepository() }
    }
    
    func addRepository(_ repo: Repository) {
        let newRepo = repo.toRepositoryEntity()
        modelContext.insert(newRepo) // Добавление нового пользователя
    }
    
    func deleteRepository(_ repo: Repository) {
        let repoToDelete = repo.toRepositoryEntity()
        modelContext.delete(repoToDelete)
    }
}
