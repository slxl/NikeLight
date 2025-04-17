//
//  ProductDetailView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: product.image)) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                } placeholder: {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.3))
                        .frame(height: 250)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(product.title)
                        .font(.title2)
                        .bold()

                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title3)
                        .foregroundColor(.green)

                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                Button {
                    // TODO: Add to cart action
                } label: {
                    Text("Add to Cart")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
