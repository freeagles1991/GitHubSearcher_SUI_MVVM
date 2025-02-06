//
//  Repositories.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import Foundation

// MARK: - Welcome
struct RepositoriesSearchResponse: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [RepositoryResponse]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
struct RepositoryResponse: Codable {
    let id: Int?
    let fullName: String?
    let owner: Owner?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case owner
        case description
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String?

    enum CodingKeys: String, CodingKey {
        case login
    }
}

