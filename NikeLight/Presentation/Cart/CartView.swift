//
//  CartView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()

    var body: some View {
        VStack {
            if viewModel.cartItems.isEmpty {
                Text("Your cart is empty")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List {
                    ForEach(viewModel.cartItems) { item in
                        HStack {
                            AsyncImage(url: URL(string: item.product.image)) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 5))

                            VStack(alignment: .leading) {
                                Text(item.product.title)
                                    .font(.headline)
                                Text("$\(item.product.price, specifier: "%.2f") x \(item.quantity)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Text("$\(item.product.price * Double(item.quantity), specifier: "%.2f")")
                                .bold()
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let item = viewModel.cartItems[index]
                            // viewModel.removeItem(item.product)
                        }
                    }
                }

                HStack {
                    Text("Total:")
                        .font(.headline)

                    Spacer()

//                    Text("$\(viewModel.total, specifier: "%.2f")")
//                        .font(.title3)
//                        .bold()
                }
                .padding([.horizontal, .top])

                Button(role: .destructive) {
                    // viewModel.clearCart()
                } label: {
                    Text("Clear Cart")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding([.horizontal, .bottom])
                }
            }
        }
        .navigationTitle("Cart")
    }
}
