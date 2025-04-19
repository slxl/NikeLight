//
//  AppEnvironment.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import SwiftData
import UIKit

// MARK: - AppEnvironment

@MainActor
struct AppEnvironment {
    let isRunningTests: Bool
    let diContainer: DIContainer
    let modelContainer: ModelContainer
    let systemEventsHandler: SystemEventsHandler
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        let session = configuredURLSession()
        let webRepositories = configuredWebRepositories(session: session)
        let modelContainer = configuredModelContainer()
        let dbRepositories = configuredDBRepositories(modelContainer: modelContainer)
        let interactors = configuredInteractors(appState: appState, webRepositories: webRepositories, dbRepositories: dbRepositories)
        let diContainer = DIContainer(appState: appState, interactors: interactors)
        let systemEventsHandler = RealSystemEventsHandler(container: diContainer)

        return AppEnvironment(
            isRunningTests: ProcessInfo.processInfo.isRunningTests,
            diContainer: diContainer,
            modelContainer: modelContainer,
            systemEventsHandler: systemEventsHandler
        )
    }

    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }

    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let imagesRepository = RealImagesWebRepository(session: session)
        let productsRepository = RealProductsWebRepository(session: session)

        return .init(images: imagesRepository, products: productsRepository)
    }

    private static func configuredDBRepositories(modelContainer: ModelContainer) -> DIContainer.DBRepositories {
        .init(cart: MainDBRepository(modelContainer: modelContainer))
    }

    private static func configuredModelContainer() -> ModelContainer {
        do {
            return try ModelContainer.appModelContainer()
        } catch {
            // Log the error
            return ModelContainer.stub
        }
    }

    private static func configuredInteractors(
        appState: Store<AppState>,
        webRepositories: DIContainer.WebRepositories,
        dbRepositories: DIContainer.DBRepositories
    ) -> DIContainer.Interactors {
        let images = RealImagesInteractor(webRepository: webRepositories.images)
        let products = RealProductsInteractor(webRepository: webRepositories.products)
        let cart = RealCartInteractor(cartRepository: dbRepositories.cart)

        return .init(images: images, products: products, cart: cart)
    }
}
