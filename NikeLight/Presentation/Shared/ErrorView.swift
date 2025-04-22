//
//  ErrorView.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import SwiftUI

// MARK: - ErrorMessageView

struct ErrorMessageView: View {
    let message: String
    let retryAction: (() -> Void)?

    init(message: String, retryAction: (() -> Void)? = nil) {
        self.message = message
        self.retryAction = retryAction
    }

    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.nike(.bold, size: 18))

            Text(message)
                .font(.nike(.regular, size: 16))
                .foregroundColor(Color.gray)

            if let retryAction {
                Button(
                    action: retryAction,
                    label: {
                        Text("Retry")
                            .font(.nike(.regular, size: 12))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                    }
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(6)
        .shadow(color: Color.gray.opacity(0.2), radius: 16)
    }
}

#Preview {
    ErrorMessageView(
        message: "Something went wrong",
        retryAction: nil
    )
}
