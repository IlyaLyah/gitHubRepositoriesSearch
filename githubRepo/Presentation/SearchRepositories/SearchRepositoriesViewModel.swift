//
//  SearchRepositoriesViewModel.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public protocol SearchRepositoriesRouter: AnyObject {
    func showDetails(for repository: Repository)
    func showError(error: Error?)
}

public protocol SearchRepositoriesViewModel {
    func loadNextRepositories(query: String, completion: @escaping (() -> ()))
    func searchRepositories(query: String, completion: @escaping (() -> ()))
    func select(repository: Repository)
    
    var cellViewModels: [RepositoryTableViewCellViewModel] { get }
}

public class SearchRepositoriesViewModelImpl: SearchRepositoriesViewModel {
    private(set) public var cellViewModels: [RepositoryTableViewCellViewModel]
    
    private let repositoryFetcher: RepositoryFetcherService
    private let imageLoader: ImageLoader
    
    private let lock = NSLock()
    
    private var currentQuery: String?
    
    private weak var router: SearchRepositoriesRouter?
    
    public init(repositoryFetcher: RepositoryFetcherService, imageLoader: ImageLoader, router: SearchRepositoriesRouter?) {
        self.repositoryFetcher = repositoryFetcher
        self.imageLoader = imageLoader
        self.router = router
        
        self.cellViewModels = []
    }
    
    public func loadNextRepositories(query: String, completion: @escaping (() -> ())) {
        repositoryFetcher.loadNextRepositoriest(query: query) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let repositories):
                self.lock.lock()
                self.cellViewModels.append(contentsOf: repositories.map { RepositoryTableViewCellViewModelImpl(
                    repository: $0,
                    imageLoader: self.imageLoader
                ) })
                self.lock.unlock()
                completion()
            case .failure(let error):
                self.router?.showError(error: error)
                completion()
            }
        }
    }
    
    public func searchRepositories(query: String, completion: @escaping (() -> ())) {
        repositoryFetcher.searchRepositories(query: query) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let repositories):
                self.lock.lock()
                self.cellViewModels = repositories.map {
                    RepositoryTableViewCellViewModelImpl(
                        repository: $0,
                        imageLoader: self.imageLoader
                    )
                }
                self.lock.unlock()
                completion()
            case .failure(let error):
                self.router?.showError(error: error)
                completion()
            }
        }
    }
    
    public func select(repository: Repository) {
        self.router?.showDetails(for: repository)
    }
}
