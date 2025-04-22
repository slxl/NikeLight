//
//  ProductsWebRepositoryTests.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

@testable import NikeLight
import Testing

@Suite(.serialized) final class ProductsWebRepositoryTests {
    private let sut = RealProductsWebRepository(session: .mockedResponsesOnly)

    typealias API = RealProductsWebRepository.API
    typealias Mock = RequestMocking.MockedResponse

    deinit {
        RequestMocking.removeAllMocks()
    }

    // MARK: - All Products

    @Test func allProductsSuccess() async throws {
        let data = await ApiModel.Product.mockedProducts
        try mock(.products, result: .success(data))
        let response = try await sut.products()

        #expect(response == data)
    }

    // MARK: - Single Product

    @Test func productByIdSuccess() async throws {
        let product = await ApiModel.Product.mockedProducts[0]
        try mock(.product(id: product.id), result: .success(product))
        let response = try await sut.product(id: product.id)

        #expect(response == product)
    }

    // MARK: - Helper

    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}
