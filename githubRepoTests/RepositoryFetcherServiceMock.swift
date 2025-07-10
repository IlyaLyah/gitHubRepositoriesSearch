//
//  RepositoryFetcherServiceMock.swift
//  githubRepoTests
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation
import githubRepo

public class RepositoryFetcherServiceMock: RepositoryFetcherService {
    public var result: Result<[githubRepo.Repository], githubRepo.RepositorySearchError>!
    
    public func loadNextRepositoriest(query: String, completion: @escaping (Result<[githubRepo.Repository], githubRepo.RepositorySearchError>) -> Void) {
        completion(.failure(.badURL))
    }
    
    public func searchRepositories(query: String, completion: @escaping (Result<[githubRepo.Repository], githubRepo.RepositorySearchError>) -> Void) {
        
        completion(.failure(.badURL))
    }

}
