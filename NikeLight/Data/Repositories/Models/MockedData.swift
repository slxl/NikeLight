//
//  MockedData.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Foundation

#if DEBUG
@MainActor
extension ApiModel.Product {
    static let mockedProducts: [ApiModel.Product] = [
        ApiModel.Product(
            id: 1,
            title: "Nike Air Max 270",
            price: 149.99,
            description: "Breathable mesh upper with Max Air unit for comfort.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/c27adfb1-347d-40a3-889c-d73857d0ab83/air-max-270-mens-shoes-KkLcGR.png"
        ),
        ApiModel.Product(
            id: 2,
            title: "Nike Air Force 1 '07",
            price: 109.99,
            description: "Classic design with bold street style and durability.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/1f7c1825-d700-4a56-90e1-3762e8b63d0e/air-force-1-07-mens-shoes-WrLlWX.png"
        ),
        ApiModel.Product(
            id: 3,
            title: "Nike Dunk Low",
            price: 119.99,
            description: "Retro basketball-inspired silhouette in fresh colorways.",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/97fdc62b-51e5-4c4f-9689-13b281502f87/dunk-low-retro-mens-shoes-87q0hf.png"
        )
    ]
}

@MainActor
extension CartItem {
    static let mockedCartItems: [CartItem] = [
        CartItem(id: 1, product: ApiModel.Product.mockedProducts[0].toDomain(), quantity: 1),
        CartItem(id: 2, product: ApiModel.Product.mockedProducts[1].toDomain(), quantity: 2),
        CartItem(id: 3, product: ApiModel.Product.mockedProducts[2].toDomain(), quantity: 1)
    ]
}
#endif
