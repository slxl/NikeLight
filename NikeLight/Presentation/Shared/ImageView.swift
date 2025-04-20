//
//  ImageView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 20/04/2025.
//

import Combine
import SwiftUI

// MARK: - ImageView

struct ImageView: View {
    private let imageURL: URL?
    @Environment(\.injected)
    var injected: DIContainer
    
    @State private var image: Loadable<UIImage>

    init(imageURL: URL?, image: Loadable<UIImage> = .notRequested) {
        self.imageURL = imageURL
        self._image = .init(initialValue: image)
    }

    var body: some View {
        switch image {
        case .notRequested:
            defaultView()

        case .isLoading:
            loadingView()

        case let .loaded(image):
            loadedView(image)

        case let .failed(error):
            failedView(error)
        }
    }
}

// MARK: - Side Effects

private extension ImageView {
    func loadImage() {
        injected.interactors.images
            .load(image: $image, url: imageURL)
    }
}

// MARK: - Content

private extension ImageView {
    func defaultView() -> some View {
        Text("").onAppear {
            self.loadImage()
        }
    }

    func loadingView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    }

    func failedView(_: Error) -> some View {
        Text("Unable to load image")
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding()
    }

    func loadedView(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
