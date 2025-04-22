//
//  AppEnvironment.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import SwiftData
import SwiftUI

// MARK: - DIContainer

struct DIContainer {
    let appState: Store<AppState>
    let interactors: Interactors

    init(appState: Store<AppState> = .init(AppState()), interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }

    init(appState: AppState, interactors: Interactors) {
        self.init(appState: Store<AppState>(appState), interactors: interactors)
    }
}

extension DIContainer {
    struct WebRepositories {
        let images: ImagesWebRepository
        let products: ProductsWebRepository
        let checkout: CheckoutWebRepository
    }

    struct DBRepositories {
        let cart: CartDatabaseRepository
    }

    struct Interactors {
        let images: ImagesInteractor
        let products: ProductsInteractor
        let cart: CartInteractor

        static var stub: Self {
            .init(
                images: StubImagesInteractor(),
                products: StubProductsInteractor(),
                cart: StubCartInteractor()
            )
        }
    }
}

extension EnvironmentValues {
    @Entry var injected: DIContainer = .init(appState: AppState(), interactors: .stub)
}

extension View {
    func inject(_ container: DIContainer) -> some View {
        self.environment(\.injected, container)
    }
}
