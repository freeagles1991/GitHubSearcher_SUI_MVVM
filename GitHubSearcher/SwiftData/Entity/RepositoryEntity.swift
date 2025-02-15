//
//  RepositoryEntity.swift
//  GitHubSearcher
//
//  Created by Дима on 11.02.2025.
//

import SwiftUI
import SwiftData

// MARK: - RepositorySwiftDataModel
@Model
final class RepositoryEntity {
    var id: UUID
    var fullName: String
    var owner: String
    var repoDescription: String?
    var ownerEmail: String
    
    init(id: UUID, fullName: String, owner: String, repoDescription: String?, ownerEmail: String) {
        self.id = id
        self.fullName = fullName
        self.owner = owner
        self.repoDescription = repoDescription
        self.ownerEmail = ownerEmail
    }
}

extension RepositoryEntity {
    func toRepository() -> Repository {
        return Repository(
            id: self.id,
            fullName: self.fullName,
            owner: self.owner,
            description: self.repoDescription,
            ownerEmail: self.ownerEmail
        )
    }
}
