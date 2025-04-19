//
//  CartItemEntity.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Foundation
import SwiftData

// MARK: - CartItem

struct CartItem: Identifiable, Codable {
    let id: Int
    let product: Product
    var quantity: Int
}

// MARK: - DBModel.CartItem

extension DBModel {
    @Model
    final class CartItem {
        @Attribute(.unique)
        var id: Int
        var productID: Int
        var title: String
        var price: Double
        var descritpion: String
        var quantity: Int
        var image: String?

        init(id: Int, productID: Int, title: String, price: Double, descritpion: String, quantity: Int, image: String?) {
            self.id = id
            self.productID = productID
            self.title = title
            self.price = price
            self.descritpion = descritpion
            self.quantity = quantity
            self.image = image
        }
    }
}

extension DBModel.CartItem {
    func toCartItem() -> CartItem {
        CartItem(
            id: self.id,
            product: Product(
                id: self.productID,
                title: self.title,
                price: self.price,
                description: self.descritpion,
                image: self.image
            ),
            quantity: self.quantity
        )
    }
}

// MARK: - Mapping Extensions

extension CartItem {
    func dbModel() -> DBModel.CartItem {
        DBModel.CartItem(
            id: id,
            productID: product.id,
            title: product.title,
            price: product.price,
            descritpion: product.description,
            quantity: quantity,
            image: product.image
        )
    }
}
