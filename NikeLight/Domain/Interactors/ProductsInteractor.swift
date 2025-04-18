//
//  ProductsInteractor.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

// MARK: - ProductsInteractor

protocol ProductsInteractor {
    func loadProducts() async throws -> [Product]
    func loadProduct(id: Int) async throws -> Product
}

// MARK: - RealProductsInteractor

struct RealProductsInteractor: ProductsInteractor {
    let webRepository: ProductsWebRepository

    func loadProducts() async throws -> [Product] {
        try await webRepository.products().map { $0.toDomain() }
    }

    func loadProduct(id: Int) async throws -> Product {
        try await webRepository.product(id: id).toDomain()
    }
}

// MARK: - StubProductsInteractor

struct StubProductsInteractor: ProductsInteractor {
    func loadProducts() async throws -> [Product] {
        []
    }

    func loadProduct(id: Int) async throws -> Product {
        Product(id: id, title: "Test", price: 9.99, description: "desc", image: "")
    }
}
