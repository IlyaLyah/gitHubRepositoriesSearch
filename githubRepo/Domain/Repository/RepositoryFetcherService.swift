//
//  RepositorySearchService.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public protocol RepositoryFetcherService {
    func loadNextRepositoriest(query: String)
}

public class RepositorySearchServiceImpl: RepositoryFetcherService {
    public init() {
        
    }
    
    public func loadNextRepositoriest(query: String) {
        
    }
}
