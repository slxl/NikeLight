//
//  MockedWebRepositories.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

import Foundation
@testable import NikeLight
import UIKit.UIImage

// MARK: - TestWebRepository

class TestWebRepository: WebRepository {
    let session: URLSession = .mockedResponsesOnly
    let baseURL = "https://test.com"
}

// MARK: - MockedProductsWebRepository

final class MockedProductsWebRepository: TestWebRepository, Mock, ProductsWebRepository {
    enum Action: Equatable {
        case products
        case product(id: Int)
    }

    var actions = MockActions<Action>(expected: [])

    var productsResponses: [Result<[ApiModel.Product], Error>] = []
    var productResponses: [Result<ApiModel.Product, Error>] = []

    func products() async throws -> [ApiModel.Product] {
        register(.products)

        guard !productsResponses.isEmpty else {
            throw MockError.valueNotSet
        }

        return try productsResponses.removeFirst().get()
    }

    func product(id: Int) async throws -> ApiModel.Product {
        register(.product(id: id))

        guard !productResponses.isEmpty else {
            throw MockError.valueNotSet
        }

        return try productResponses.removeFirst().get()
    }
}

// MARK: - MockedImageWebRepository

final class MockedImageWebRepository: TestWebRepository, Mock, ImagesWebRepository {
    enum Action: Equatable {
        case loadImage(URL)
    }

    var actions = MockActions<Action>(expected: [])

    var imageResponses: [Result<UIImage, Error>] = []

    func loadImage(url: URL) async throws -> UIImage {
        register(.loadImage(url))

        guard !imageResponses.isEmpty else {
            throw MockError.valueNotSet
        }

        return try imageResponses.removeFirst().get()
    }
}

// MARK: - MockedCheckoutWebRepository

final class MockedCheckoutWebRepository: TestWebRepository, Mock, CheckoutWebRepository {
    enum Action: Equatable {
        case simulateCheckout
    }

    var actions = MockActions<Action>(expected: [])

    var checkoutResponse: [Result<Bool, Error>] = []

    func simulateCheckout() async throws -> Bool {
        register(.simulateCheckout)

        guard !checkoutResponse.isEmpty else {
            throw MockError.valueNotSet
        }

        return try checkoutResponse.removeFirst().get()
    }
}
