//
//  ProductListViewModel.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Combine
import Foundation

@MainActor
final class ProductListViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var productRowViewModels: [ProductRowViewModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let webRepository: ProductsWebRepository

    // MARK: - Init

    init(webRepository: ProductsWebRepository) {
        self.webRepository = webRepository
    }

    // MARK: - Load Products

    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            let apiProducts = try await webRepository.products()
            self.productRowViewModels = apiProducts.map(ProductRowViewModel.init)
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
