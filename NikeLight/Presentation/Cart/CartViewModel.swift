//
//  CartViewModel.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Foundation
import SwiftUI

@MainActor
class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []

//    private let cartRepository: CartRepository
//
//    init(cartRepository: CartRepository) {
//        self.cartRepository = cartRepository
//        loadCart()
//    }
//
//    func loadCart() {
//        cartItems = cartRepository.getCartItems()
//    }
//
//    func removeItem(_ product: Product) {
//        cartRepository.removeProductFromCart(product)
//        loadCart()
//    }
//
//    func clearCart() {
//        cartRepository.clearCart()
//        loadCart()
//    }
//
//    var total: Double {
//        cartItems.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
//    }
}
