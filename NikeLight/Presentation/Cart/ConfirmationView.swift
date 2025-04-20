//
//  ConfirmationView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 19/04/2025.
//

import SwiftUI

// MARK: - ConfirmationView

struct ConfirmationView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Checkout Successful!")
                .font(.nike(.bold, size: 18))
                .padding()

            Button(action: {
                isPresented = false
            }, label: {
                Text("Done")
                    .font(.nike(.regular, size: 12))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)
            })
        }
        .padding()
        .background(Color.white)
        .cornerRadius(6)
        .shadow(color: Color.gray.opacity(0.2), radius: 16)
    }
}
