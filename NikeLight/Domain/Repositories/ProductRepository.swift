//
//  ProductRepositoryImpl.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//
import Foundation

protocol ProductRepository {
    func fetchProducts() async throws -> [Product]
    func fetchProductDetails(id: Int) async throws -> Product
}
