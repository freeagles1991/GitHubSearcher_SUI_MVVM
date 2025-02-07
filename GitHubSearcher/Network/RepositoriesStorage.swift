//
//  RepositoriesStorage.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import Foundation

class RepositoriesStorage: ObservableObject {
    @Published var repositories: [RepositoryModel] = []
}

