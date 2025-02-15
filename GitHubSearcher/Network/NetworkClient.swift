//
//  NetworkClient.swift
//  GitHubSearcher
//
//  Created by Дима on 05.02.2025.
//

import Foundation

protocol NetworkClientProtocol {
    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func get<T: Decodable>(from url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func cancelCurrentTask()
}

final class NetworkClient: NetworkClientProtocol {
    
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    private var currentTask: URLSessionDataTask?

    // MARK: - Initializer
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    // MARK: - Methods
    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        currentTask?.cancel()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.noData))
            }
        }
        currentTask = task
        task.resume()
    }

    func get<T: Decodable>(from url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        get(from: url) { result in
            switch result {
            case .success(let data):
                self.parse(data: data, type: type, onResponse: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func cancelCurrentTask() {
        currentTask?.cancel()
    }

    // MARK: - Private

    private func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
        do {
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            onResponse(.failure(NetworkError.parsingError))
        }
    }
}

// MARK: - Errors
enum NetworkError: Error {
    case invalidResponse
    case noData
    case parsingError
}



