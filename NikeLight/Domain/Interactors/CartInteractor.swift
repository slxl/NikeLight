//
//  CartInteractor.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

// MARK: - CartInteractor

protocol CartInteractor {
    /// Load cart contents, used for app launch or reload
    func loadCart() async throws -> [CartItem]

    /// Clear the entire cart
    func clearCart() async throws

    /// Adjusts product quantity
    func setProductQuantity(_ product: Product, quantity: Int) async throws

    /// Remove all quantities of a specific product from the cart
    func removeProduct(_ product: Product) async throws
}

// MARK: - RealCartInteractor

struct RealCartInteractor: CartInteractor {
    let cartRepository: CartDatabaseRepository

    func loadCart() async throws -> [CartItem] {
        try await cartRepository.loadCart()
    }

    func clearCart() async throws {
        try await cartRepository.clearCart()
    }

    func setProductQuantity(_ product: Product, quantity: Int) async throws {
        if quantity == 0 {
            // If quantity is 0, we remove the product from the cart
            try await cartRepository.removeProduct(product)
        } else {
            // Otherwise, we set the specified quantity
            try await cartRepository.setProductQuantity(product, quantity: quantity)
        }
    }

    func removeProduct(_ product: Product) async throws {
        try await cartRepository.removeProduct(product)
    }
}

// MARK: - StubCartInteractor

struct StubCartInteractor: CartInteractor {
    private var items: [CartItem] = []

    func loadCart() async throws -> [CartItem] {
        []
    }

    func clearCart() async throws {
        // no-op
    }

    func setProductQuantity(_ product: Product, quantity: Int) async throws {
        // no-op
    }

    func removeProduct(_: Product) async throws {
        // no-op
    }
}
