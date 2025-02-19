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
    
    func addRepository(_ repo: Repository, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !repositoryExists(repo) else {
            print("[DEBUG] Репозиторий '\(repo.fullName)' уже существует, добавление отменено")
            completion(.failure(NSError(domain: "RepositoryError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Репозиторий уже существует"])))
            return
        }

        let newRepo = repo.toRepositoryEntity()
        modelContext.insert(newRepo)

        saveChanges { result in
            switch result {
            case .success:
                self.loadFavoriteRepositories()
                print("[DEBUG] Репозиторий '\(repo.fullName)' добавлен")
                completion(.success(()))
            case .failure(let error):
                print("[ERROR] Ошибка сохранения изменений: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func deleteRepository(_ repo: Repository, completion: @escaping (Result<Void, Error>) -> Void) {
        let request = FetchDescriptor<RepositoryEntity>()
        do {
            let entities = try self.modelContext.fetch(request)
            if let existingRepo = entities.first(where: { $0.id == repo.id }) {
                self.modelContext.delete(existingRepo)
                
                self.saveChanges { result in
                    switch result {
                    case .success:
                        self.loadFavoriteRepositories()
                        print("[DEBUG] Репозиторий '\(repo.fullName)' удален")
                        completion(.success(()))
                    case .failure(let error):
                        print("[ERROR] Ошибка сохранения изменений: \(error)")
                        completion(.failure(error))
                    }
                }
            } else {
                print("[DEBUG] Репозиторий '\(repo.fullName)' не найден для удаления")
                completion(.failure(NSError(domain: "RepositoryError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Репозиторий не найден для удаления"])))
            }
        } catch {
            print("[ERROR] Ошибка удаления: \(error)")
            completion(.failure(error))
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
    
    func clearAllRepositories(completion: @escaping (Result<Void, Error>) -> Void) {
        let request = FetchDescriptor<RepositoryEntity>()
        
        do {
            let entities = try self.modelContext.fetch(request)
            let count = entities.count
            for repo in entities {
                self.modelContext.delete(repo)
            }
            
            saveChanges { result in
                switch result {
                case .success:
                    self.loadFavoriteRepositories()
                    print("[DEBUG] Удалены все (\(count)) репозитории")
                    completion(.success(()))  // Уведомляем об успешном завершении
                case .failure(let error):
                    print("[ERROR] Ошибка сохранения изменений: \(error)")
                    completion(.failure(error))  // Уведомляем об ошибке
                }
            }
        } catch {
            print("[ERROR] Ошибка очистки данных: \(error)")
            completion(.failure(error))  // Уведомляем об ошибке
        }
    }
    
    private func saveChanges(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try self.modelContext.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}
