//
//  ProductTileView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import SwiftUI

// MARK: - ProductTileView

struct ProductTileView: View {
    let product: Product
    let tileSize: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            if let imageURLString = product.image, let imageURL = URL(string: imageURLString) {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.1)

                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFit()
                            .background(.white)
                            .frame(width: tileSize * 0.5, height: tileSize * 0.5)
                            .offset(y: tileSize * 0.1)

                    case .failure:
                        Color.red.opacity(0.2)

                    @unknown default:
                        Color.gray
                    }
                }
                .frame(width: tileSize, height: tileSize)
                .clipped()
            } else {
                Color.gray.opacity(0.1)
                    .frame(width: tileSize, height: tileSize)
                    .cornerRadius(10)
            }

            Text(product.title)
                .font(.nike(.boldCondencedMedium, size: 11))
                .textCase(.uppercase)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .foregroundColor(.black)
                .padding(12)
        }
        .frame(width: tileSize, height: tileSize)
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(.secondary, lineWidth: 0.5))
        .cornerRadius(6)
    }
}

#Preview {
    ProductTileView(
        product: Product(
            id: 1,
            title: "Nike Air Max",
            price: 123.3,
            description: "Nike shoes",
            image: "https://static.nike.com/a/images/t_PDP_1728_v1/f_auto,q_auto:eco/e0a19996-b64a-458d-855a-1e508832736d/NIKE+AIR+MAX+1+ESS.png"
        ), tileSize: 150
    )
}
