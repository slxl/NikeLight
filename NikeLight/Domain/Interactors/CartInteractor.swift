//
//  CartInteractor.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

// MARK: - CartInteractor

@MainActor
protocol CartInteractor {
    func addToCart(_ product: Product) async throws
    func removeFromCart(_ product: Product) async throws
    func getCartItems() async throws -> [CartItem]
    func clearCart() async throws
}

// MARK: - StubCartInteractor

// struct RealCartInteractor: CartInteractor {
//    let cartRepository: CartRepository
//
//    func addToCart(_ product: Product) async throws {
//        try await cartRepository.addProductToCart(product)
//    }
//
//    func removeFromCart(_ product: Product) async throws {
//        try await cartRepository.remove(product: product)
//    }
//
//    func getCartItems() async throws -> [CartItem] {
//        try await cartRepository.items()
//    }
//
//    func clearCart() async throws {
//        try await cartRepository.clear()
//    }
// }

struct StubCartInteractor: CartInteractor {
    private var items: [CartItem] = []

    func addToCart(_: Product) async throws {
        // no-op
    }

    func removeFromCart(_: Product) async throws {
        // no-op
    }

    func getCartItems() async throws -> [CartItem] {
        items
    }

    func clearCart() async throws {
        // no-op
    }
}
