//
//  Product.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Foundation

// MARK: - Product

struct Product: Identifiable, Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let image: String
}

// MARK: - ApiModel.Product

extension ApiModel {
    struct Product: Identifiable, Codable, Hashable {
        let id: Int
        let title: String
        let price: Double
        let description: String
        let image: String
    }
}

extension ApiModel.Product {
    func toDomain() -> Product {
        Product(
            id: self.id,
            title: self.title,
            price: self.price,
            description: self.description,
            image: self.image
        )
    }
}
