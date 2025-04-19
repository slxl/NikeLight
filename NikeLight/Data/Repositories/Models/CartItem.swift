//
//  CartItemEntity.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Foundation
import SwiftData

struct CartItem: Identifiable, Codable {
    let id: Int
    let product: Product
    var quantity: Int
}

extension DBModel {
    @Model
    final class CartItem {
        @Attribute(.unique)
        var id: Int
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
}
