//
//  RepositorySearchFetcher.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public struct RepositorySearchResponse: Decodable {
    public let items: [Repository]
}

public protocol RepositorySearchFetcher {
    func fetchRepositories(query: String, page: Int?, completion: @escaping (Result<[Repository], RepositorySearchError>) -> Void)
}

public struct RepositorySearchFetcherImpl: RepositorySearchFetcher {
    public func fetchRepositories(query: String, page: Int?, completion: @escaping (Result<[Repository], RepositorySearchError>) -> Void) {
        guard !query.isEmpty else {
            completion(.success([]))
            return
        }
        
        var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")

        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: String(page ?? 0))
        ]
        
        guard let url = urlComponents?.url else {
            completion(.failure(.badURL))
            return
        }
        
        let urlSessionConfig: URLSessionConfiguration = .default
        let session = URLSession(configuration: urlSessionConfig)
        let decoder = JSONDecoder()

        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 422 {
                completion(.success([]))
                return
            }
            
            guard let data else {
                completion(.failure(.responseError(nil)))
                return
            }
            
            if let result = try? decoder.decode(RepositorySearchResponse.self, from: data) {
                completion(.success(result.items))
            } else {
                completion(.failure(.responseError(error)))
            }
        }.resume()
    }
}
