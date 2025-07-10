//
//  RepositorySearchFetcherMock.swift
//  githubRepoTests
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation
import githubRepo

public class RepositorySearchFetcherMockMock: RepositorySearchFetcher {
    public var result: Result<[githubRepo.Repository], githubRepo.RepositorySearchError>!
    
    public func fetchRepositories(query: String, page: Int?, completion: @escaping (Result<[githubRepo.Repository], githubRepo.RepositorySearchError>) -> Void) {
        completion(result)
    }
}
