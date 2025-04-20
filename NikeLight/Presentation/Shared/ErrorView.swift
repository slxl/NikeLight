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
                .font(.title)

            Text(message)
                .font(.nike(.regular, size: 16))
                .foregroundColor(.red)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()

            if let retryAction {
                Button(
                    action: retryAction,
                    label: {
                        Text("Retry")
                            .bold()
                    }
                )
            }
        }
    }
}

#Preview {
    ErrorMessageView(
        message: "Something went wrong",
        retryAction: nil
    )
}
