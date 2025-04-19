import SwiftUI

// MARK: - CartView

struct CartView: View {
    @State private var cartItems: [CartItem] = []
    @State private var promocode: String = ""
    @State private var promocodeDiscount: Double = 0.0
    @State private var totalAmount: Double = 0.0
    @State private var isLoading: Bool = false
    @State private var isCheckoutInProgress: Bool = false
    @State private var isCheckoutSuccess: Bool = false
    @State private var errorMessage: String? = nil

    @Environment(\.injected)
    private var injected: DIContainer

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                if cartItems.isEmpty && !isLoading {
                    Spacer()

                    Text("Your cart is empty")
                        .font(.nike(.regular, size: 18))
                        .foregroundColor(.secondary)

                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(cartItems, id: \.product.id) { cartItem in
                                CartItemView(
                                    cartItem: cartItem,
                                    onQuantityChange: { product, newQuantity in
                                        updateCartItem(product: product, quantity: newQuantity)
                                    },
                                    onRemoveItem: { product in
                                        removeCartItem(product: product)
                                    }
                                )
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    .scrollIndicators(.hidden)

                    if !cartItems.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Enter YOUAREHIRED promocode to get a discount")
                                .font(.nike(.regular, size: 14))

                            HStack {
                                TextField("Promo Code", text: $promocode)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.nike(.regular, size: 16))

                                Button(action: {
                                    applyPromoCode()
                                }) {
                                    Text("Apply")
                                        .font(.nike(.regular, size: 12))
//                                        .fixedSize(horizontal: true, vertical: true)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(6)
                                }
                                .disabled(isLoading || isCheckoutInProgress)
                            }
                        }
                    }

                        Button(action: {
                            initiateCheckout()
                        }) {
                            Text("Pay €\(totalAmount, specifier: "%.2f")")
                                .font(.nike(.regular, size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.primary)
                                .cornerRadius(6)
                        }
                        .disabled(isLoading || isCheckoutInProgress)

                        Button(action: {
                            Task { await clearCart() }
                        }) {
                            Text("Empty Cart")
                                .font(.nike(.regular, size: 16))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                        .disabled(isLoading || isCheckoutInProgress)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)

            if isCheckoutInProgress {
                ProgressView("Processing Checkout...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(24)
                    .background(Color.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
            }

            if let errorMessage {
                ErrorMessageView(message: errorMessage)
            }

            if isCheckoutSuccess {
                ConfirmationView(isPresented: $isCheckoutSuccess)
            }
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadCartItems()
        }
    }

    // MARK: - Methods

    private func loadCartItems() {
        Task {
            isLoading = true
            defer { isLoading = false }

            do {
                let items = try await injected.interactors.cart.loadCart()
                cartItems = items
                updateTotal()
            } catch {
                errorMessage = "Failed to load cart."
            }
        }
    }

    private func updateCartItem(product: Product, quantity: Int) {
        Task {
            do {
                try await injected.interactors.cart.setProductQuantity(product, quantity: quantity)
                loadCartItems()
            } catch {
                errorMessage = "Failed to update item."
            }
        }
    }

    private func removeCartItem(product: Product) {
        Task {
            do {
                try await injected.interactors.cart.removeProduct(product)
                loadCartItems()
            } catch {
                errorMessage = "Failed to remove item."
            }
        }
    }

    private func applyPromoCode() {
        promocodeDiscount = promocode == "YOUAREHIRED" ? 0.99 : 0
        updateTotal()
    }

    private func updateTotal() {
        totalAmount = cartItems.reduce(0) { $0 + $1.product.price * Double($1.quantity) } * (1 - promocodeDiscount)
    }

    private func initiateCheckout() {
        isCheckoutInProgress = true
        errorMessage = nil

        Task {
            await simulatePollingForPaymentCompletion()
        }
    }

    private func simulatePollingForPaymentCompletion() async {
        let timeout: TimeInterval = 60
        let pollingInterval: TimeInterval = 3
        let endpoint = "https://httpbin.org/delay/3"

        var timeElapsed: TimeInterval = 0
        while timeElapsed < timeout {
            do {
                let url = URL(string: endpoint)!
                let (_, response) = try await URLSession.shared.data(from: url)

                if (response as? HTTPURLResponse)?.statusCode == 200 {
                    isCheckoutSuccess = true
                    await clearCart()
                    break
                }
            } catch {
                errorMessage = "Error: Network failure during payment simulation."
                break
            }

            timeElapsed += pollingInterval
            await Task.sleep(UInt64(pollingInterval * 1_000_000_000))
        }

        if !isCheckoutSuccess {
            errorMessage = "Error: Payment timeout. Please try again."
        }

        isCheckoutInProgress = false
    }

    private func clearCart() async {
        do {
            try await injected.interactors.cart.clearCart()
        } catch {
            errorMessage = "Error: Could not clear cart from server."
        }

        cartItems.removeAll()
        totalAmount = 0
    }
}

// MARK: - ErrorMessageView

struct ErrorMessageView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.nike(.regular, size: 16))
            .foregroundColor(.red)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
    }
}


