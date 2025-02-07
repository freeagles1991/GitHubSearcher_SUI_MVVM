//
//  Repositories.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import Foundation

// MARK: - Welcome
struct RepositoriesSearchResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [RepositoryResponse]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
struct RepositoryResponse: Codable {
    let id: Int
    let fullName: String
    let owner: Owner
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
        case description
    }
}

extension RepositoryResponse {
    var toRepositoryModel: RepositoryModel {
        let repository = RepositoryModel(
            id: self.id,
            fullName: self.fullName,
            owner: self.owner.login,
            description: self.description,
            ownerEmail: "")
        return repository
    }
}



// MARK: - Owner
struct Owner: Codable {
    let login: String

    enum CodingKeys: String, CodingKey {
        case login
    }
}

// MARK: - RepositoryLightweight
struct RepositoryModel {
    let id: Int
    let fullName: String
    let owner: String
    let description: String?
    let ownerEmail: String
    
    static var defaultRepoItem = RepositoryModel(
        id: 1,
        fullName: "Default Repo",
        owner: "NoName",
        description: "Default description",
        ownerEmail: "@ya.com")
}

