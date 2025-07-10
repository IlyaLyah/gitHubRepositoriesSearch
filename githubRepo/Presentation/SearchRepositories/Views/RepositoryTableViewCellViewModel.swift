//
//  RepositoryTableViewCellViewModel.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public protocol RepositoryTableViewCellViewModel {
    var name: String { get }
    var description: String { get }
    var avatarPath: String? { get }
    var repository: Repository { get }
    
    var imageLoader: ImageLoader { get }
    
    var starsViewModel: StarsCounterViewModel { get }
}

public struct RepositoryTableViewCellViewModelImpl: RepositoryTableViewCellViewModel {
    public let name: String
    public let description: String
    public let avatarPath: String?
    public let repository: Repository
    
    public let imageLoader: ImageLoader
    
    public let starsViewModel: StarsCounterViewModel
    
    public init(repository: Repository, imageLoader: ImageLoader) {
        self.repository = repository
        self.name = repository.name
        self.description = repository.description ?? ""
        self.avatarPath = repository.owner.avatarPath
        self.imageLoader = imageLoader
        self.starsViewModel = StarsCounterViewModelImpl(count: repository.starsCount)
    }
}
