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

    @Environment(\.presentationMode)
    var presentationMode

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    GeometryReader { geo in
                        let dimension: CGFloat = geo.size.width - 32

                        AsyncImage(url: URL(string: product.image)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: dimension, height: dimension)
                                .clipped()
                                .cornerRadius(20)
                        } placeholder: {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                                .frame(width: dimension, height: dimension)
                                .cornerRadius(20)
                        }
                        .frame(height: dimension)
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

            // Sticky Bottom Bar
            HStack {
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.nike(.regular, size: 16))
                    .bold()

                Spacer()

                Group {
                    if isAddedToCart {
                        HStack(spacing: 12) {
                            Button(action: {
                                if quantity > 1 {
                                    quantity -= 1
                                } else {
                                    isAddedToCart = false
                                    quantity = 0
                                }
                            }, label: {
                                Image(systemName: "minus")
                            })

                            Text("\(quantity)")
                                .font(.nike(.regular, size: 16))
                                .frame(minWidth: 24)

                            Button(action: {
                                quantity += 1
                            }, label: {
                                Image(systemName: "plus")
                            })
                        }
                        .padding()
                        .frame(width: 160) // Matches button size
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    } else {
                        Button(action: {
                            isAddedToCart = true
                            quantity = 1
                            // TODO: Add to cart logic
                        }, label: {
                            Text("Add to Cart")
                                .frame(maxWidth: .infinity)
                                .font(.nike(.regular, size: 16))
                        })
                        .padding()
                        .frame(width: 160) // Matches counter button
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(
                Color(UIColor.systemBackground)
                    .clipShape(
                        RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                    )
                    .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: -6)
                    .ignoresSafeArea(edges: .bottom) // Extend behind the Tab Bar
            )
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
    }
}
