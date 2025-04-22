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

/// A protocol that defines the operations for fetching image data from the web.
///
/// This protocol includes a method for loading an image from a specified URL. The image can either be fetched from the cache or downloaded from the server.
protocol ImagesWebRepository: WebRepository {
    /// Loads an image from a given URL.
    ///
    /// This method attempts to fetch the image from the cache first. If not found, it downloads the image from the server.
    ///
    /// - Parameter url: The URL of the image to load.
    /// - Returns: A `UIImage` object representing the image fetched from the URL.
    /// - Throws: An error if the image cannot be fetched or deserialized, such as network errors or invalid image data.
    ///
    /// This method ensures efficient image loading by caching the image once downloaded.
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
