//
//  ProductListView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import SwiftUI

// MARK: - ProductListView

struct ProductListView: View {
    @StateObject private var viewModel: ProductListViewModel

    // swiftlint:disable:next type_contents_order
    init(webRepository: ProductsWebRepository) {
        _viewModel = StateObject(wrappedValue: ProductListViewModel(webRepository: webRepository))
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("NikeLight")
                .navigationDestination(for: ProductRowViewModel.self) { rowViewModel in
                    ProductDetailView(
                        product: Product(
                            id: rowViewModel.id,
                            title: rowViewModel.title,
                            price: 5,
                            description: "Temp description",
                            image: "rowViewModel.imageURL?.absoluteString!"
                        )
                    )
                }
                .task {
                    await viewModel.loadProducts()
                }
        }
    }

    @ViewBuilder private var content: some View {
        if viewModel.isLoading {
            ProgressView("Loading...")
        } else if let error = viewModel.errorMessage {
            Text("Error: \(error)")
                .foregroundColor(.red)
        } else {
            List(viewModel.productRowViewModels) { productRowViewModel in
                NavigationLink(value: productRowViewModel) {
                    HStack {
                        AsyncImage(url: productRowViewModel.imageURL) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))

                        VStack(alignment: .leading) {
                            Text(productRowViewModel.title)
                                .font(.headline)
                            Text("€" + productRowViewModel.price)
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
    }
}

// MARK: ProductListView.Routing

extension ProductListView {
    struct Routing: Equatable {
        var countryCode: String?
    }
}
