//
//  User.swift
//  GitHubSearcher
//
//  Created by Дима on 09.02.2025.
//

struct UserResponse: Codable {
    let email: String?

    enum CodingKeys: String, CodingKey {
        case email
    }
}
