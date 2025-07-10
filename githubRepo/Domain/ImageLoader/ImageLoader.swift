//
//  ImageLoader.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import Foundation

public protocol ImageLoader {
    func loadImage(url: URL) async -> Data?
}

public class ImageLoaderImpl: ImageLoader {
    public func loadImage(url: URL) async -> Data? {
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            return data
        } catch {
            return nil
        }
    }
}
