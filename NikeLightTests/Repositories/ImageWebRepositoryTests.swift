//
//  ImageWebRepositoryTests.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

import Testing
import UIKit.UIImage
@testable import NikeLight

@Suite(.serialized) final class ImageWebRepositoryTests {

    private let sut = RealImagesWebRepository(session: .mockedResponsesOnly)
    private let testImage = UIColor.red.image(CGSize(width: 40, height: 40))

    typealias Mock = RequestMocking.MockedResponse

    deinit {
        RequestMocking.removeAllMocks()
    }

    @Test func loadImageSuccess() async throws {
        let imageURL = try #require(URL(string: "https://image.service.com/myimage.png"))
        let imageRef = try #require(testImage.pngData())
        let mock = Mock(url: imageURL, result: .success(imageRef))
        RequestMocking.add(mock: mock)

        let result = try await sut.loadImage(url: imageURL)
        #expect(result.size == testImage.size)
    }
}

