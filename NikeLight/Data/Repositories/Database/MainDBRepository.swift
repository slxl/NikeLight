//
//  MainDBRepository.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Foundation
import SwiftData

extension ModelContainer {
    static func appModelContainer(inMemoryOnly: Bool = false, isStub: Bool = false) throws -> ModelContainer {
        let schema = Schema.appSchema
        let modelConfiguration = ModelConfiguration(isStub ? "stub" : nil, schema: schema, isStoredInMemoryOnly: inMemoryOnly)

        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }

    static var stub: ModelContainer {
        try! appModelContainer(inMemoryOnly: true, isStub: true) // swiftlint:disable:this force_try
    }

    var isStub: Bool {
        configurations.first?.name == "stub"
    }
}

// MARK: - MainDBRepository

@ModelActor
final actor MainDBRepository {}

// MARK: CartDatabaseRepository

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
