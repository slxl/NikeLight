//
//  ProductDetailView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import SwiftUI

// MARK: - ProductDetailView

struct ProductDetailView: View {
    let product: Product

    @State private var quantity: Int = 0
    @State private var isAddedToCart: Bool = false
    @State private var isLoadingQuantity: Bool = true

    @Environment(\.presentationMode)
    var presentationMode

    @Environment(\.injected)
    private var injected: DIContainer

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    GeometryReader { geo in
                        let dimension: CGFloat = geo.size.width - 32
                        ImageView(imageURL: product.imageUrl)
                            .frame(width: dimension, height: dimension)
                            .clipped()
                            .cornerRadius(20)
                            .padding(.horizontal)
                    }
                    .frame(height: UIScreen.main.bounds.width - 32)

                    Text(product.title)
                        .font(.nike(.boldCondencedExtraBold, size: 24))
                        .bold()

                    Text(product.description)
                        .font(.nike(.regular, size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 120) // Space for sticky  bar
                .padding()
            }

            stickyBarView
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
            }
        }
        .onAppear {
            Task {
                await loadCartQuantity()
            }
        }
    }

    @ViewBuilder var stickyBarView: some View {
        HStack {
            Text("€\(product.price, specifier: "%.2f")")
                .font(.nike(.regular, size: 16))
                .bold()

            Spacer()

            Group {
                if isLoadingQuantity {
                    ProgressView()
                        .frame(width: 160, height: 44)
                } else {
                    ZStack {
                        if quantity > 0 {
                            counterView
                                .transition(.opacity)
                        } else {
                            addToCartButton
                                .transition(.opacity)
                        }
                    }
                    .animation(.easeInOut(duration: 0.15), value: quantity > 0)
                    .frame(width: 160)
                }
            }
        }
        .padding()
        .background(
            Color(UIColor.systemBackground)
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: -6)
                .ignoresSafeArea(edges: .bottom) // Extend behind the Tab Bar
        )
    }

    // MARK: - Components

    private var counterView: some View {
        HStack(spacing: 12) {
            Button(action: {
                quantity = max(0, quantity - 1)
                updateCartItem(quantity: quantity)
            }, label: {
                Image(systemName: "minus")
            })

            Text("\(quantity)")
                .font(.nike(.regular, size: 16))
                .frame(minWidth: 24)

            Button(action: {
                quantity += 1
                updateCartItem(quantity: quantity)

            }, label: {
                Image(systemName: "plus")
            })
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1)
        )
        .foregroundColor(.black)
        .cornerRadius(10)
    }

    private var addToCartButton: some View {
        Button(action: {
            quantity = 1
            updateCartItem(quantity: quantity)

        }, label: {
            Text("Add to Cart")
                .frame(maxWidth: .infinity)
                .font(.nike(.regular, size: 16))
        })
        .padding()
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    // MARK: - DB Logic

    private func loadCartQuantity() async {
        isLoadingQuantity = true

        defer {
            isLoadingQuantity = false
        }

        do {
            let items = try await injected.interactors.cart.loadCart()

            if let existing = items.first(where: { $0.product.id == product.id }) {
                quantity = existing.quantity
            } else {
                quantity = 0
            }
        } catch {
            // handle error if needed
        }
    }

    private func updateCartItem(quantity: Int) {
        Task {
            do {
                // Use updateCartItem to set the quantity in the cart
                try await injected.interactors.cart.setProductQuantity(product, quantity: quantity)
            } catch {
                // handle error
            }
        }
    }
}
