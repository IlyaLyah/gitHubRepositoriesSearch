//
//  NetworkError.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public enum RepositorySearchError: Error, Equatable {
    public static func == (lhs: RepositorySearchError, rhs: RepositorySearchError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL):
            return true
        case (responseError(let lhsError), responseError(let rhsError)):
            return lhsError?.localizedDescription == rhsError?.localizedDescription
        default:
            return false
        }
    }
    
    case responseError(Error?)
    case badURL
}
