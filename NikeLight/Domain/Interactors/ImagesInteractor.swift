//
//  ImagesInteractor.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Combine
import Foundation
import SwiftUI

// MARK: - ImagesInteractor

protocol ImagesInteractor {
    func load(image: LoadableSubject<UIImage>, url: URL?)
}

// MARK: - RealImagesInteractor

struct RealImagesInteractor: ImagesInteractor {
    let webRepository: ImagesWebRepository

    init(webRepository: ImagesWebRepository) {
        self.webRepository = webRepository
    }

    func load(image: LoadableSubject<UIImage>, url: URL?) {
        guard let url else {
            image.wrappedValue = .notRequested
            return
        }

        image.load {
            try await webRepository.loadImage(url: url)
        }
    }
}

// MARK: - StubImagesInteractor

struct StubImagesInteractor: ImagesInteractor {
    func load(image: LoadableSubject<UIImage>, url: URL?) {}
}
