//
//  RepositorySearchFetcher.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public enum RepositorySearchError: Error {
    case searchError(Error?)
}

public struct RepositorySearchResponse: Decodable {
    public let items: [Repository]
}

public protocol RepositorySearchFetcher {
    func fetchRepositories(query: String, page: Int?, completion: @escaping (Result<[Repository], RepositorySearchError>) -> Void)
}

public struct RepositorySearchFetcherImpl: RepositorySearchFetcher {
    public func fetchRepositories(query: String, page: Int?, completion: @escaping (Result<[Repository], RepositorySearchError>) -> Void) {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page ?? 0)") else {
            completion(.failure(.searchError(nil)))
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
                completion(.failure(.searchError(nil)))
                return
            }
            
            if let result = try? decoder.decode(RepositorySearchResponse.self, from: data) {
                completion(.success(result.items))
            } else {
                completion(.failure(.searchError(error)))
            }
        }.resume()
    }
}
