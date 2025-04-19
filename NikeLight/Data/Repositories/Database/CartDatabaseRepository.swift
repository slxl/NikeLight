//
//  CartDatabaseRepository.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Foundation
import SwiftData

// MARK: - CartDatabaseRepository

protocol CartDatabaseRepository {
    // save whole cart on exit
    func store(cartItems: [CartItem]) async throws

    func storeCartItem(_ item: CartItem) async throws
    func fetchCartItems() async throws -> [CartItem]
    func removeCartItem(_ item: CartItem) async throws
    func clearCart() async throws
}

// MARK: - CartItemEntity

@Model
final class CartItemEntity {
    @Attribute(.unique) var id: Int
    var productID: Int
    var title: String
    var price: Double
    var quantity: Int
    var image: String?

    init(id: Int, productID: Int, title: String, price: Double, quantity: Int, image: String?) {
        self.id = id
        self.productID = productID
        self.title = title
        self.price = price
        self.quantity = quantity
        self.image = image
    }
}

// MARK: - Mapping Extensions

extension CartItem {
    func dbModel() -> CartItemEntity {
        CartItemEntity(
            id: id,
            productID: product.id,
            title: product.title,
            price: product.price,
            quantity: quantity,
            image: product.image
        )
    }
}

extension CartItemEntity {
    func toCartItem() -> CartItem {
        CartItem(
            id: id,
            product: Product(
                id: productID,
                title: title,
                price: price,
                description: "", // Placeholder
                image: image ?? ""
            ),
            quantity: quantity
        )
    }
}

// MARK: - MainDBRepository + CartDatabaseRepository

extension MainDBRepository: CartDatabaseRepository {
    func store(cartItems: [CartItem]) async throws {
        try modelContext.transaction {
            cartItems
                .map { $0.dbModel() }
                .forEach { modelContext.insert($0) }
        }
    }

    func storeCartItem(_ item: CartItem) async throws {
        try modelContext.transaction {
            let entity = item.dbModel()
            modelContext.insert(entity)
        }
    }

    @MainActor
    func fetchCartItems() async throws -> [CartItem] {
        let fetchDescriptor = FetchDescriptor<CartItemEntity>()
        return try modelContainer.mainContext.fetch(fetchDescriptor).map { $0.toCartItem() }
    }

    @MainActor
    func removeCartItem(_ item: CartItem) async throws {
        let fetchDescriptor = FetchDescriptor<CartItemEntity>(
            predicate: #Predicate { $0.id == item.id }
        )
        let matching = try modelContainer.mainContext.fetch(fetchDescriptor)
        matching.forEach { modelContainer.mainContext.delete($0) }
    }

    @MainActor
    func clearCart() async throws {
        let fetchDescriptor = FetchDescriptor<CartItemEntity>()
        let allItems = try modelContainer.mainContext.fetch(fetchDescriptor)
        allItems.forEach { modelContainer.mainContext.delete($0) }
    }
}
