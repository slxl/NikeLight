//
//  CartDBRepositoryTests.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

import Foundation
@testable import NikeLight
import SwiftData
import Testing

@MainActor
@Suite struct CartDBRepositoryTests {
    let container: ModelContainer
    let sut: CartDatabaseRepository

    init() async throws {
        container = .mock
        sut = MainDBRepository(modelContainer: container)

        // Clear existing items to start fresh
        try await sut.clearCart()

        // Prefill mocked items
        let mockedItems = CartItem.mockedCartItems

        for item in mockedItems {
            try await sut.setProductQuantity(item.product, quantity: item.quantity)
        }
    }

    @Test func loadCart() async throws {
        let cartItems = CartItem.mockedCartItems
        _ = try await sut.loadCart()

        let results = try container.mainContext
            .fetch(FetchDescriptor<DBModel.CartItem>()).map { $0.toCartItem() }

        #expect(results.count == cartItems.count)
    }

    @Test func clearCart() async throws {
        try await sut.clearCart()
        let results = try container.mainContext
            .fetch(FetchDescriptor<DBModel.CartItem>())

        #expect(results.isEmpty)
    }

    @Test func setProductQuantity_addsNewProduct() async throws {
        let product = Product(
            id: 12412,
            title: "Nike Air Max",
            price: 99.99,
            description: "Breathable mesh upper with Max Air unit for comfort.",
            image: ""
        )

        try await sut.setProductQuantity(product, quantity: 3)

        let results = try container.mainContext
            .fetch(FetchDescriptor<DBModel.CartItem>(
                predicate: #Predicate { $0.productID == product.id }
            ))

        #expect(results.count == 1)
        #expect(results.first?.quantity == 3)
    }

    @Test func setProductQuantity_updatesExistingProduct() async throws {
        let existing = try container.mainContext
            .fetch(FetchDescriptor<DBModel.CartItem>())
            .first!
        let product = Product(id: existing.productID, title: existing.title, price: existing.price, description: existing.descritpion, image: existing.image)

        try await sut.setProductQuantity(product, quantity: 7)

        let updated = try container.mainContext
            .fetch(FetchDescriptor<DBModel.CartItem>(
                predicate: #Predicate { $0.productID == product.id }
            ))
            .first

        #expect(updated?.quantity == 7)
    }

    @Test func setProductQuantity_removesIfZero() async throws {
        let existing = try container.mainContext
            .fetch(FetchDescriptor<DBModel.CartItem>())
            .first!
        let product = Product(id: existing.productID, title: existing.title, price: existing.price, description: existing.descritpion, image: existing.image)

        try await sut.setProductQuantity(product, quantity: 0)

        let results = try container.mainContext
            .fetch(FetchDescriptor<DBModel.CartItem>(
                predicate: #Predicate { $0.productID == product.id }
            ))

        #expect(results.isEmpty)
    }

    @Test func removeProduct_deletesCorrectly() async throws {
        let existing = try container.mainContext
            .fetch(FetchDescriptor<DBModel.CartItem>())
            .first!
        let product = Product(id: existing.productID, title: existing.title, price: existing.price, description: existing.descritpion, image: existing.image)

        try await sut.removeProduct(product)

        let results = try container.mainContext
            .fetch(FetchDescriptor<DBModel.CartItem>(
                predicate: #Predicate { $0.productID == product.id }
            ))

        #expect(results.isEmpty)
    }
}
