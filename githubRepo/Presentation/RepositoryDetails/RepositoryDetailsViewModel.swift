//
//  RepositoryDetailsViewModel.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public protocol RepositoryDetailsRouter: AnyObject {
    func openLink(link: URL)
}

public protocol RepositoryDetailsViewModel {
    var name: String { get }
    var description: String { get }
    var avatarPath: String? { get }
    var issuesCount: Int { get }
    var forksCount: Int { get }
    var repositoryPath: String? { get }
    
    var imageLoader: ImageLoader { get }
    
    var starsViewModel: StarsCounterViewModel { get }
    
    func repositoryLinkTapped()
}

public struct RepositoryDetailsViewModelImpl: RepositoryDetailsViewModel {
    public let name: String
    public let description: String
    public let avatarPath: String?
    public let issuesCount: Int
    public let forksCount: Int
    public let repositoryPath: String?
    
    public let imageLoader: ImageLoader
    
    public let starsViewModel: StarsCounterViewModel
    
    private weak var router: RepositoryDetailsRouter?
    
    public init(repository: Repository, imageLoader: ImageLoader, router: RepositoryDetailsRouter) {
        self.name = repository.name
        self.description = repository.description ?? ""
        self.avatarPath = repository.owner.avatarPath
        self.imageLoader = imageLoader
        self.starsViewModel = StarsCounterViewModelImpl(count: repository.starsCount)
        self.issuesCount = repository.issuesCount
        self.forksCount = repository.forksCount
        self.repositoryPath = repository.urlPath
        self.router = router
    }
    
    public func repositoryLinkTapped() {
        guard let repositoryPath = self.repositoryPath, let link = URL(string: repositoryPath) else {
            return
        }
        
        self.router?.openLink(link: link)
    }
}
