//
//  ProductsInteractor.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

// MARK: - ProductsInteractor

/// A protocol that defines the operations for interacting with products.
///
/// This protocol includes methods for loading a list of products and loading a single product by its ID.
protocol ProductsInteractor {

    /// Loads the list of all available products.
    ///
    /// - Returns: An array of `Product` objects representing all products.
    /// - Throws: An error if the products cannot be fetched, such as a network issue or failure in data retrieval.
    ///
    /// This method retrieves all products available in the system.
    func loadProducts() async throws -> [Product]

    /// Loads the details of a specific product by its unique ID.
    ///
    /// - Parameter id: The unique identifier of the product to load.
    /// - Returns: A `Product` object representing the requested product.
    /// - Throws: An error if the product cannot be fetched, such as a network issue, database failure, or invalid product ID.
    ///
    /// This method retrieves the product details for a specific product based on its ID.
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
