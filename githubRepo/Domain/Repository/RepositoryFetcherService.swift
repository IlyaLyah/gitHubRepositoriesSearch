//
//  RepositorySearchService.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public protocol RepositoryFetcherService {
    func loadNextRepositoriest(query: String, completion: @escaping (Result<[Repository], RepositorySearchError>) -> Void)
    func searchRepositories(query: String, completion: @escaping (Result<[Repository], RepositorySearchError>) -> Void)
}

public class RepositoryFetcherServiceImpl: RepositoryFetcherService {
    private let repositoriesSearchFetcher: RepositorySearchFetcher
    private let lock = NSLock()
    
    private var currentPage = 0
    
    public init(repositoriesSearchFetcher: RepositorySearchFetcher) {
        self.repositoriesSearchFetcher = repositoriesSearchFetcher
    }
    
    public func loadNextRepositoriest(query: String, completion: @escaping (Result<[Repository], RepositorySearchError>) -> Void) {
        repositoriesSearchFetcher.fetchRepositories(query: query, page: currentPage) { [weak self] result in
            guard let self else {
                completion(.failure(.responseError(nil)))
                return
            }
            self.lock.lock()
            currentPage += 1
            self.lock.unlock()
            completion(result)
        }
    }
    
    public func searchRepositories(query: String, completion: @escaping (Result<[Repository], RepositorySearchError>) -> Void) {
        currentPage = 0
        repositoriesSearchFetcher.fetchRepositories(query: query, page: currentPage) { [weak self] result in
            guard let self else {
                completion(.failure(.responseError(nil)))
                return
            }
            self.lock.lock()
            currentPage += 1
            self.lock.unlock()
            completion(result)
        }
    }
}
