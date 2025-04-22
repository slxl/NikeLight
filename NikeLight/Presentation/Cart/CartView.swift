import SwiftUI

// MARK: - CartView

struct CartView: View {
    private enum Constants {
        static let validPromocode = "YOUAREHIRED"
        static let discount = 99
    }

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

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter \(Constants.validPromocode) promocode to get a \(Constants.discount)% discount")
                            .font(.nike(.regular, size: 14))

                        HStack {
                            TextField("Promo Code", text: $promocode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.nike(.regular, size: 16))

                            Button(action: {
                                applyPromoCode()
                            }, label: {
                                Text("Apply")
                                    .font(.nike(.regular, size: 12))
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(6)
                            })
                            .disabled(isLoading || isCheckoutInProgress)
                        }
                    }

                    Button(action: {
                        initiateCheckout()
                    }, label: {
                        Text("Pay €\(totalAmount, specifier: "%.2f")")
                            .font(.nike(.regular, size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.primary)
                            .cornerRadius(6)
                    })
                    .disabled(isLoading || isCheckoutInProgress)

                    Button(action: {
                        Task { await clearCart() }
                    }, label: {
                        Text("Empty Cart")
                            .font(.nike(.regular, size: 16))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                    })
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
        promocodeDiscount = promocode == Constants.validPromocode ? Double(Constants.discount) : 0
        updateTotal()
    }

    private func updateTotal() {
        let totalBeforeDiscount = cartItems.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
        totalAmount = ((100.0 - promocodeDiscount) / 100.0) * totalBeforeDiscount
    }

    private func initiateCheckout() {
        isCheckoutInProgress = true
        errorMessage = nil

        Task {
            do {
                let success = try await injected.interactors.cart.checkoutCart()

                if success {
                    isCheckoutSuccess = true
                    await clearCart()
                } else {
                    errorMessage = "Error: Payment was not successful. Please try again."
                }
            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
            }

            isCheckoutInProgress = false
        }
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
