//
//  ImageWebRepository.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Combine
import Foundation
import class UIKit.UIImage


// MARK: - ImagesWebRepository

protocol ImagesWebRepository: WebRepository {
    func loadImage(url: URL) async throws -> UIImage
}

// MARK: - RealImagesWebRepository

struct RealImagesWebRepository: ImagesWebRepository {
    let session: URLSession
    let baseURL: String

    init(session: URLSession) {
        self.session = session
        self.baseURL = ""
    }

    func loadImage(url: URL) async throws -> UIImage {
        if let cached = ImageCache.shared.image(for: url) {
            return cached
        }

        let (localURL, _) = try await session.download(from: url)
        let data = try Data(contentsOf: localURL)

        guard let image = UIImage(data: data) else {
            throw APIError.imageDeserialization
        }

        ImageCache.shared.insert(image, for: url)
        
        return image
    }
}
