//
//  githubRepoTests.swift
//  githubRepoTests
//
//  Created by Ilya Liakh on 17.06.25.
//

import Testing
import githubRepo

struct githubRepoTests {
    @Test func example() async throws {
        var repositoryNetworkMock = RepositorySearchFetcherMockMock()
        var repositoryFetcherService = RepositoryFetcherServiceImpl(repositoriesSearchFetcher: repositoryNetworkMock)

        repositoryNetworkMock.result = .failure(.badURL)
        
        repositoryFetcherService.searchRepositories(query: "") { result in
            #expect(result == .failure(.badURL))
        }
    }
}
 
