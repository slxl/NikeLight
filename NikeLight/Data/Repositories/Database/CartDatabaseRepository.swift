//
//  CartDatabaseRepository.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Foundation
import SwiftData

// MARK: - CartDatabaseRepository

/// A protocol defining the operations for interacting with the cart database.
protocol CartDatabaseRepository {
    /// Loads the current cart items from the database.
    ///
    /// - Returns: An array of `CartItem` objects representing the items currently in the cart.
    /// - Throws: An error if loading the cart fails (e.g., database access issues).
    func loadCart() async throws -> [CartItem]

    /// Clears all items from the cart in the database.
    ///
    /// - Throws: An error if clearing the cart fails (e.g., database write issues).
    func clearCart() async throws

    /// Updates the quantity of a specific product in the cart.
    ///
    /// - Parameters:
    ///   - product: The `Product` to update the quantity for.
    ///   - quantity: The new quantity to set for the product.
    /// - Throws: An error if updating the product quantity fails (e.g., database write issues).
    func setProductQuantity(_ product: Product, quantity: Int) async throws

    /// Removes a specific product from the cart.
    ///
    /// - Parameters:
    ///   - product: The `Product` to remove from the cart.
    /// - Throws: An error if removing the product fails (e.g., database write issues).
    func removeProduct(_ product: Product) async throws
}
