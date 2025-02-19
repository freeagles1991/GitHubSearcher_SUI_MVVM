//
//  DataLoader.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//
import Foundation

protocol DataLoaderProtocol {
    func fetchRepoData(with params: [String: String], completion: @escaping (Result<[Repository], Error>) -> Void) 
    func fetchUserData(with userName: String, completion: @escaping (Result<UserResponse, Error>) -> Void)
    func cancelCurrentTask()
}

struct DataLoader: DataLoaderProtocol{
    let networkClient: NetworkClientProtocol
    let repositoriesStorage: RepositoriesStorage
    
    init(networkClient: NetworkClientProtocol, repositoriesStorage: RepositoriesStorage) {
        self.networkClient = networkClient
        self.repositoriesStorage = repositoriesStorage
    }
    
    func fetchRepoData(with params: [String: String], completion: @escaping (Result<[Repository], Error>) -> Void) {
        guard let baseUrl = URL(string: GlobalConstants.baseRepoUrl.rawValue),
              var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        else {return}
        
        components.queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = components.url else {
            fatalError("Невозможно создать URL")
        }

        networkClient.get(from: url, type: RepositoriesSearchResponse.self) { result in
            switch result {
            case .success(let response):
                guard let items = response.items else { return }
                DispatchQueue.main.async {
                    let repos = items.map { $0.toRepositoryModel }
                    self.repositoriesStorage.repositories = repos
                    print("Всего загружено \(self.repositoriesStorage.repositories.map { $0.fullName } ) репозиториев")
                    completion(.success(repos))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("\(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchUserData(with userName: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        guard let url = URL(string: GlobalConstants.baseUsersUrl.rawValue + "/\(userName)")
        else {return}
        
        networkClient.get(from: url, type: UserResponse.self) { result in
            completion(result)
        }
    }
    
    func cancelCurrentTask() {
        networkClient.cancelCurrentTask()
    }
}

