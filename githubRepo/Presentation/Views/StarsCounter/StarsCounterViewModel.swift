//
//  StarsCounterViewModel.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public protocol StarsCounterViewModel {
    var count: Int { get }
}

public struct StarsCounterViewModelImpl: StarsCounterViewModel {
    public let count: Int
    
    public init(count: Int) {
        self.count = count
    }
}
