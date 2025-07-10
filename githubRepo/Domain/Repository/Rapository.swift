//
//  Rapository.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public struct Repository: Decodable, Equatable {
    public let name: String
    public let description: String?
    public let forksCount: Int
    public let issuesCount: Int
    public let starsCount: Int
    public let urlPath: String
    public let owner: RepositoryOwner
    
    enum CodingKeys: String, CodingKey {
        case name, owner, description
        case forksCount = "forks_count"
        case issuesCount = "open_issues_count"
        case urlPath = "html_url"
        case starsCount = "stargazers_count"
    }
}

public struct RepositoryOwner: Decodable, Equatable {
    public let avatarPath: String?
    
    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_url"
    }
}
