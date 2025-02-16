//
//  RepositoriesStorage.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import Foundation

final class RepositoriesStorage: ObservableObject  {
    @Published var repositories: [Repository] = []
    
    func clearStorage() {
        repositories = []
    }
}

