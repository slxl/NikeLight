//
//  ProductsInteractorTests.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 18/04/2025.
//

@testable import NikeLight
import SwiftUI
import Testing

// MARK: - ProductsInteractorTests

@MainActor
@Suite class ProductsInteractorTests {
    let mockedWebRepo: MockedProductsWebRepository
    let sut: RealProductsInteractor

    init() {
        mockedWebRepo = MockedProductsWebRepository()
        sut = RealProductsInteractor(webRepository: mockedWebRepo)
    }
}

// MARK: - RefreshProductsListTests

final class RefreshProductsListTests: ProductsInteractorTests {
    @Test func happyPath() async throws {
        let products = ApiModel.Product.mockedProducts

        mockedWebRepo.actions = .init(expected: [
            .products
        ])

        mockedWebRepo.productsResponses = [.success(products)]

        _ = try await sut.loadProducts()

        mockedWebRepo.verify()
    }

    @Test func webFailure() async throws {
        mockedWebRepo.actions = .init(expected: [
            .products
        ])

        let error = NSError.test
        mockedWebRepo.productsResponses = [.failure(error)]

        await #expect(throws: error) {
            _ = try await self.sut.loadProducts()
        }

        mockedWebRepo.verify()
    }
}

// MARK: - LoadProductByIDTests

final class LoadProductByIDTests: ProductsInteractorTests {
    @Test func happyPath() async throws {
        let product = ApiModel.Product.mockedProducts.first!
        mockedWebRepo.actions = .init(expected: [
            .product(id: product.id)
        ])
        mockedWebRepo.productResponses = [.success(product)]

        let result = try await sut.loadProduct(id: product.id)

        #expect(result.id == product.id)
        mockedWebRepo.verify()
    }

    @Test func productNotFound() async throws {
        let productId = 999
        let error = NSError.test
        mockedWebRepo.actions = .init(expected: [
            .product(id: productId)
        ])

        mockedWebRepo.productResponses = [.failure(error)]

        await #expect(throws: error) {
            _ = try await self.sut.loadProduct(id: productId)
        }

        mockedWebRepo.verify()
    }
}
