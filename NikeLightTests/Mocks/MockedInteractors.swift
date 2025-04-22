//
//  MockedInteractors.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

@testable import NikeLight
import SwiftUI
import Testing

extension DIContainer.Interactors {
    static func mocked(
        images: [MockedImagesInteractor.Action] = [],
        products: [MockedProductsInteractor.Action] = [],
        cart: [MockedCartInteractor.Action] = [],
    ) -> DIContainer.Interactors {
        self.init(
            images: MockedImagesInteractor(expected: images),
            products: MockedProductsInteractor(expected: products),
            cart: MockedCartInteractor(expected: cart)
        )
    }

    func verify(sourceLocation: SourceLocation = #_sourceLocation) {
        (images as? MockedImagesInteractor)?
            .verify(sourceLocation: sourceLocation)

        (products as? MockedProductsInteractor)?
            .verify(sourceLocation: sourceLocation)

        (cart as? MockedCartInteractor)?
            .verify(sourceLocation: sourceLocation)
    }
}

// MARK: - MockedProductsInteractor

struct MockedProductsInteractor: Mock, ProductsInteractor {
    enum Action: Equatable {
        case loadProducts
        case loadProduct(id: Int)
    }

    let actions: MockActions<Action>
    var productResponse: Result<Product, Error> = .failure(MockError.valueNotSet)
    var productsResponse: Result<[Product], Error> = .failure(MockError.valueNotSet)

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }

    func loadProducts() async throws -> [Product] {
        register(.loadProducts)

        return try productsResponse.get()
    }

    func loadProduct(id: Int) async throws -> Product {
        register(.loadProduct(id: id))

        return try productResponse.get()
    }
}

// MARK: - MockedImagesInteractor

struct MockedImagesInteractor: Mock, ImagesInteractor {
    enum Action: Equatable {
        case loadImage(URL?)
    }

    let actions: MockActions<Action>

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }

    func load(image: LoadableSubject<UIImage>, url: URL?) {
        register(.loadImage(url))
    }
}

// MARK: - MockedCartInteractor

struct MockedCartInteractor: Mock, CartInteractor {
    enum Action: Equatable {
        case loadCart
        case clearCart
        case setProductQuantity(product: Product, quantity: Int)
        case remove(product: Product)
        case checkoutCart
    }

    let actions: MockActions<Action>
    var cartItemsResponse: Result<[CartItem], Error> = .failure(MockError.valueNotSet)
    var checkoutResponse: Result<Bool, Error> = .failure(MockError.valueNotSet)

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }

    func loadCart() async throws -> [CartItem] {
        register(.loadCart)

        return try cartItemsResponse.get()
    }

    func clearCart() async throws {
        register(.clearCart)
    }

    func setProductQuantity(_ product: Product, quantity: Int) async throws {
        register(.setProductQuantity(product: product, quantity: quantity))
    }

    func removeProduct(_ product: Product) async throws {
        register(.remove(product: product))
    }

    func checkoutCart() async throws -> Bool {
        register(.checkoutCart)

        return try checkoutResponse.get()
    }
}
