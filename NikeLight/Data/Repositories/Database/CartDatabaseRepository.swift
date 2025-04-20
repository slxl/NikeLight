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
    func loadCart() async throws -> [CartItem]
    func clearCart() async throws
    func setProductQuantity(_ product: Product, quantity: Int) async throws
    func removeProduct(_ product: Product) async throws
}

// MARK: - MainDBRepository + CartDatabaseRepository

extension MainDBRepository: CartDatabaseRepository {
    @MainActor
    func loadCart() async throws -> [CartItem] {
        let fetchDescriptor = FetchDescriptor<DBModel.CartItem>()
        return try modelContainer.mainContext
            .fetch(fetchDescriptor)
            .map { $0.toCartItem() }
    }

    func clearCart() async throws {
        try modelContext.transaction {
            let fetchDescriptor = FetchDescriptor<DBModel.CartItem>()
            let allItems = try modelContext.fetch(fetchDescriptor)
            allItems.forEach { modelContext.delete($0) }
        }

        try modelContext.save()
    }

    func setProductQuantity(_ product: Product, quantity: Int) async throws {
        try modelContext.transaction {
            let fetchDescriptor = FetchDescriptor<DBModel.CartItem>(
                predicate: #Predicate { $0.productID == product.id }
            )
            let matching = try modelContext.fetch(fetchDescriptor)

            if let existing = matching.first {
                if quantity == 0 {
                    modelContext.delete(existing)
                } else {
                    existing.quantity = quantity
                }
            } else if quantity > 0 {
                // If the product is not in the cart and quantity is greater than 0, add it
                let newItem = DBModel.CartItem(
                    id: product.id,
                    productID: product.id,
                    title: product.title,
                    price: product.price,
                    descritpion: product.description,
                    quantity: quantity,
                    image: product.image
                )
                modelContext.insert(newItem)
            }
        }

        try modelContext.save()
    }

    func removeProduct(_ product: Product) async throws {
        try modelContext.transaction {
            let fetchDescriptor = FetchDescriptor<DBModel.CartItem>(
                predicate: #Predicate { $0.productID == product.id }
            )

            let matching = try modelContext.fetch(fetchDescriptor)
            matching.forEach { modelContext.delete($0) }
        }

        try modelContext.save()
    }
}
