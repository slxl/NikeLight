//
//  ProductListView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import SwiftUI

// MARK: - ProductListView

struct ProductListView: View {
    @State private var products: [Product] = []
    @State private var navigationPath = NavigationPath()
    @State private(set) var productsState: Loadable<Void>
    @State private var isRefreshing = false
    @State private var fadeIn: Bool = false // State to track fade-in animation

    @Environment(\.injected)
    private var injected: DIContainer

    // swiftlint:disable:next type_contents_order
    init(state: Loadable<Void> = .notRequested) {
        self._productsState = .init(initialValue: state)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            content
                .navigationTitle("Shop")
                .navigationBarTitleDisplayMode(.inline)
        }
        // .onReceive(routingUpdate) { self.routingState = $0 }
        // .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }

    @ViewBuilder private var content: some View {
        switch productsState {
        case .notRequested:
            defaultView()

        case .isLoading:
            loadingView()

        case .loaded:
            loadedView()

        case let .failed(error):
            failedView(error)
        }
    }

    private var tileSize: CGFloat {
        // Make square tiles based on screen width
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 8
        let totalSpacing = spacing * 3 // left + middle + right

        return (screenWidth - totalSpacing) / 2
    }
}

// MARK: ProductListView.Routing

extension ProductListView {
    struct Routing: Equatable {
        var productId: Int?
    }
}

@MainActor
private extension ProductListView {
    @ViewBuilder
    func loadedView() -> some View {
        if products.isEmpty {
            Text("No products available")
                .font(.footnote)
        } else {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.fixed(tileSize), spacing: 8),
                    GridItem(.fixed(tileSize), spacing: 8)
                ], spacing: 8) {
                    ForEach(products) { product in
                        NavigationLink(value: product) {
                            ProductTileView(product: product, tileSize: tileSize)
                        }
                    }
                }
                .padding(.top, 8)
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
            .refreshable {
                if !isRefreshing {
                    isRefreshing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        loadProducts(forceReload: true)
                        isRefreshing = false
                    }
                }
            }
            //        .onChange(of: routingState.productId, initial: true, { _, code in
            //            guard let code,
            //                  let product = products.first(where: { $0.id == productId})
            //            else { return }
            //            navigationPath.append(product)
            //        })
            //        .onChange(of: navigationPath, { _, path in
            //            if !path.isEmpty {
            //                routingBinding.wrappedValue.productId = nil
            //            }
            //        })
        }
    }
}

// MARK: - Loading Content

private extension ProductListView {
    func defaultView() -> some View {
        Text("")
            .onAppear {
                if !products.isEmpty {
                    productsState = .loaded(())
                }

                loadProducts(forceReload: false)
            }
    }

    func loadingView() -> some View {
        ProgressView("Loading...")
            .progressViewStyle(CircularProgressViewStyle())
    }

    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            loadProducts(forceReload: true)
        })
    }
}

// MARK: - Side Effects

private extension ProductListView {
    private func loadProducts(forceReload: Bool) {
        guard forceReload || products.isEmpty else {
            return
        }

        $productsState.load {
            let loadedProducts = try await injected.interactors.products.loadProducts()

            await MainActor.run {
                self.products = loadedProducts
            }
        }
    }
}
