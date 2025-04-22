//
//  ProductsWebRepository.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Foundation

// MARK: - ProductsWebRepository

/// A protocol for interacting with the web service related to products.
///
/// This protocol defines methods for fetching products and specific product details from a web repository.
protocol ProductsWebRepository: WebRepository {
    /// Fetches a list of all products from the web repository.
    ///
    /// - Returns: An array of `ApiModel.Product` objects representing all available products.
    /// - Throws: An error if the fetch operation fails, such as a network error or a server issue.
    ///
    /// This method is asynchronous and must be called within an asynchronous context.
    func products() async throws -> [ApiModel.Product]

    /// Fetches the details of a specific product by its ID.
    ///
    /// - Parameter id: The unique identifier of the product to fetch.
    /// - Returns: An `ApiModel.Product` object representing the product with the specified ID.
    /// - Throws: An error if the fetch operation fails, such as a network error, server issue, or if no product with the given ID exists.
    ///
    /// This method is asynchronous and must be called within an asynchronous context.
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
