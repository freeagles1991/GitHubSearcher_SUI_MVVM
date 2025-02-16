//
//  SwiftDataStoreController.swift
//  GitHubSearcher
//
//  Created by Дима on 11.02.2025.
//

import SwiftUI
import SwiftData

@MainActor
final class SwiftDataStoreController: ObservableObject {
    private let modelContext: ModelContext
    @Published var favoriteRepositories: [Repository] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadFavoriteRepositories()
    }
    
    func loadFavoriteRepositories() {
        let request = FetchDescriptor<RepositoryEntity>()
        DispatchQueue.main.async {
            do {
                let entities = try self.modelContext.fetch(request)
                let repositories = entities.map { $0.toRepository() }
                
                self.favoriteRepositories = repositories
                print("[DEBUG] Загружено \(self.favoriteRepositories.map { $0.fullName}) репозиторов")
            } catch {
                print("[ERROR] Ошибка загрузки данных: \(error)")
            }
        }
    }
    
    func addRepository(_ repo: Repository) {
        guard !repositoryExists(repo) else {
            print("[DEBUG] Репозиторий '\(repo.fullName)' уже существует, добавление отменено")
            return
        }

        let newRepo = repo.toRepositoryEntity()
        modelContext.insert(newRepo)
        
        saveChanges()
        
        loadFavoriteRepositories()
        print("[DEBUG] Репозиторий '\(repo.fullName)' добавлен")
    }
    
    func deleteRepository(_ repo: Repository) {
        let request = FetchDescriptor<RepositoryEntity>()
        DispatchQueue.main.async {
            do {
                let entities = try self.modelContext.fetch(request)
                if let existingRepo = entities.first(where: { $0.id == repo.id }) {
                    self.modelContext.delete(existingRepo)
                    
                    self.saveChanges()
                    
                    self.loadFavoriteRepositories()
                    
                    print("[DEBUG] Репозиторий '\(repo.fullName)' удален")
                } else {
                    print("[DEBUG] Репозиторий '\(repo.fullName)' не найден для удаления")
                }
            } catch {
                print("[ERROR] Ошибка удаления: \(error)")
            }
        }
    }
    
    func repositoryExists(_ repo: Repository) -> Bool {
        let request = FetchDescriptor<RepositoryEntity>()
        do {
            let entities = try modelContext.fetch(request)
            let exists = entities.contains { $0.id == repo.id }
            print("[DEBUG] Проверка существования '\(repo.fullName)': \(exists ? "Да" : "Нет")")
            return exists
        } catch {
            print("[ERROR] Ошибка при проверке существования: \(error)")
            return false
        }
    }
    
    func clearAllRepositories() {
        let request = FetchDescriptor<RepositoryEntity>()
        DispatchQueue.main.async {
            do {
                let entities = try self.modelContext.fetch(request)
                let count = entities.count
                for repo in entities {
                    self.modelContext.delete(repo)
                }
                
                self.saveChanges()
                
                self.loadFavoriteRepositories()
                
                print("[DEBUG] Удалены все (\(count)) репозитории")
            } catch {
                print("[ERROR] Ошибка очистки данных: \(error)")
            }
        }
    }
    
    private func saveChanges() {
        do {
            try modelContext.save()
            print("[DEBUG] Изменения сохранены")
        } catch {
            print("[ERROR] Ошибка сохранения данных: \(error)")
        }
    }
}
