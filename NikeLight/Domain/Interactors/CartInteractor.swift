//
//  CartInteractor.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

// MARK: - CartInteractor

/// A protocol that defines the operations for managing a user's shopping cart.
///
/// This protocol includes methods for loading, clearing, updating product quantities,
/// removing products, and simulating the checkout process.
protocol CartInteractor {
    /// Loads the contents of the cart.
    ///
    /// - Returns: An array of `CartItem` objects representing the items currently in the cart.
    /// - Throws: An error if the cart cannot be loaded, such as a network or database failure.
    ///
    /// This method is used when the app is launched or when the cart needs to be reloaded.
    func loadCart() async throws -> [CartItem]

    /// Clears the entire cart.
    ///
    /// - Throws: An error if the cart cannot be cleared, such as a database or network issue.
    ///
    /// This method removes all items from the cart and resets the cart's state.
    func clearCart() async throws

    /// Adjusts the quantity of a specific product in the cart.
    ///
    /// - Parameters:
    ///   - product: The product whose quantity needs to be updated.
    ///   - quantity: The new quantity for the product.
    /// - Throws: An error if the quantity update fails, such as a database or network issue.
    ///
    /// This method allows modifying the quantity of an item already in the cart. If the product
    /// doesn't exist in the cart, it will be added with the specified quantity.
    func setProductQuantity(_ product: Product, quantity: Int) async throws

    /// Removes all quantities of a specific product from the cart.
    ///
    /// - Parameter product: The product to remove from the cart.
    /// - Throws: An error if the product cannot be removed, such as a database or network failure.
    ///
    /// This method deletes the product entirely from the cart.
    func removeProduct(_ product: Product) async throws

    /// Simulates the checkout process for the cart.
    ///
    /// - Returns: A `Bool` indicating whether the checkout was successful (`true`) or not (`false`).
    /// - Throws: An error if the checkout process fails, such as a network or payment failure.
    ///
    /// This method simulates completing the purchase for all items in the cart.
    func checkoutCart() async throws -> Bool
}

// MARK: - RealCartInteractor

struct RealCartInteractor: CartInteractor {
    let checklutRepository: CheckoutWebRepository
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

    func checkoutCart() async throws -> Bool {
        try await checklutRepository.simulateCheckout()
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

    func checkoutCart() async throws -> Bool {
        true
    }
}
