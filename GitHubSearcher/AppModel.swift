//
//  AppModel.swift
//  GitHubSearcher
//
//  Created by Дима on 15.02.2025.
//

import SwiftData

@MainActor
@Observable
class AppModel {
    let modelContainer: ModelContainer
    let dataStore: SwiftDataStoreController

    init() {
        do {
            modelContainer = try ModelContainer(for: RepositoryEntity.self)
            dataStore = SwiftDataStoreController(modelContext: modelContainer.mainContext)
        } catch {
            fatalError("Ошибка инициализации SwiftData: \(error)")
        }
    }
}
