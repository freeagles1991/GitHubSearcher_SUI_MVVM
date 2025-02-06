//
//  DataLoader.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//
import Foundation

protocol DataLoaderProtocol {
    func fetchData(with params: [String: String])
}

struct DataLoader: DataLoaderProtocol{
    let networkClient: NetworkClientProtocol
    let repositoriesStorage: RepositoriesStorage
    
    init(networkClient: NetworkClientProtocol, repositoriesStorage: RepositoriesStorage) {
        self.networkClient = networkClient
        self.repositoriesStorage = repositoriesStorage
    }
    
    func fetchData(with params: [String: String]) {
        guard let baseUrl = URL(string: GlobalConstants.baseUrl.rawValue),
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
                repositoriesStorage.repositories = response.items ?? []
                print("Всего загружено \(repositoriesStorage.repositories.map { $0.fullName } ) репозиториев")
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    
}

