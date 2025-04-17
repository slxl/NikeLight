//
//  ProductRowViewModel.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Foundation

struct ProductRowViewModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let price: String
    let imageURL: URL?

    init(_ product: ApiModel.Product) {
        self.id = product.id
        self.title = product.title
        self.price = String(format: "$%.2f", product.price)
        self.imageURL = URL(string: product.image)
    }
}
