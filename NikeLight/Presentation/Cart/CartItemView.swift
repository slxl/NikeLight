//
//  CartItemView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 19/04/2025.
//

import SwiftUI

// MARK: - CartItemView

struct CartItemView: View {
    let cartItem: CartItem
    let onQuantityChange: (Product, Int) -> Void
    let onRemoveItem: (Product) -> Void

    var body: some View {
        HStack {
            ImageView(imageURL: cartItem.product.imageUrl)
                .frame(width: 40, height: 40)
                .clipped()

            VStack(alignment: .leading) {
                Text(cartItem.product.title)
                    .font(.nike(.regular, size: 14))
                    .lineLimit(1)

                Text("€\(cartItem.product.price * Double(cartItem.quantity), specifier: "%.2f")")
                    .font(.nike(.regular, size: 12))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Quantity Controls
            HStack(spacing: 8) {
                Button(action: {
                    onQuantityChange(cartItem.product, cartItem.quantity - 1)
                }, label: {
                    Image(systemName: "minus")
                        .foregroundColor(cartItem.quantity == 1 ? .gray : .primary)
                })
                .disabled(cartItem.quantity == 1)

                Text("\(cartItem.quantity)")
                    .font(.nike(.regular, size: 16))

                Button(action: {
                    onQuantityChange(cartItem.product, cartItem.quantity + 1)
                }, label: {
                    Image(systemName: "plus")
                })
            }
            .padding(.horizontal)

            Button(action: {
                onRemoveItem(cartItem.product)
            }, label: {
                Image(systemName: "trash")
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            })
        }
        .padding()
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(.secondary, lineWidth: 0.5))
        .cornerRadius(6)
    }
}
