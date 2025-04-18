//
//  ProductsWebRepository.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Foundation

// MARK: - ProductsWebRepository

protocol ProductsWebRepository: WebRepository {
    func products() async throws -> [ApiModel.Product]
    func product(id: Int) async throws -> ApiModel.Product
}

// MARK: - RealProductsWebRepository

struct RealProductsWebRepository: ProductsWebRepository {
    let session: URLSession
    let baseURL: String

    init(session: URLSession) {
        self.session = session
        self.baseURL = "https://fakestoreapi.com"
    }

    func products() async throws -> [ApiModel.Product] {
        try await call(endpoint: API.products)
    }

    func product(id: Int) async throws -> ApiModel.Product {
        try await call(endpoint: API.product(id: id))
    }
}

// MARK: RealProductsWebRepository.API

extension RealProductsWebRepository {
    enum API {
        case products
        case product(id: Int)
    }
}

// MARK: - RealProductsWebRepository.API + APICall

extension RealProductsWebRepository.API: APICall {
    var path: String {
        switch self {
        case .products:
            return "/products"

        case let .product(id):
            return "/products/\(id)"
        }
    }

    var method: String {
        switch self {
        case .product, .products:
            return "GET"
        }
    }

    var headers: [String: String]? {
        ["Accept": "application/json"]
    }

    func body() throws -> Data? {
        nil
    }
}
