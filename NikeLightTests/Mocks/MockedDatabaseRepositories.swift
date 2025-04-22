//
//  MockedDBRepositories.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

@testable import NikeLight
import SwiftData

// MARK: - MockedCartDBRepository

final class MockedCartDBRepository: Mock, CartDatabaseRepository {
    enum Action: Equatable {
        case loadCart
        case clearCart
        case setProductQuantity(_ product: Product, quantity: Int)
        case removeProduct(_ product: Product)
    }

    var actions = MockActions<Action>(expected: [])

    var loadCartResults: [Result<[CartItem], Error>] = []
    var clearCartResults: [Result<Void, Error>] = []
    var setProductQuantityResults: [Result<Void, Error>] = []
    var removeProductResults: [Result<Void, Error>] = []

    // MARK: - API

    func loadCart() async throws -> [CartItem] {
        register(.loadCart)

        guard !loadCartResults.isEmpty else {
            throw MockError.valueNotSet
        }

        return try loadCartResults.removeFirst().get()
    }

    func clearCart() async throws {
        register(.clearCart)

        guard !clearCartResults.isEmpty else {
            throw MockError.valueNotSet
        }

        try clearCartResults.removeFirst().get()
    }

    func setProductQuantity(_ product: Product, quantity: Int) async throws {
        register(.setProductQuantity(product, quantity: quantity))

        guard !setProductQuantityResults.isEmpty else {
            throw MockError.valueNotSet
        }

        try setProductQuantityResults.removeFirst().get()
    }

    func removeProduct(_ product: Product) async throws {
        register(.removeProduct(product))

        guard !removeProductResults.isEmpty else {
            throw MockError.valueNotSet
        }

        try removeProductResults.removeFirst().get()
    }
}

extension ModelContainer {
    static var mock: ModelContainer {
        try! appModelContainer(inMemoryOnly: true, isStub: false)
    }
}
