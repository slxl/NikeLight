//
//  SystemEventsHandler.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Combine
import UIKit

// MARK: - SystemEventsHandler

@MainActor
protocol SystemEventsHandler {
    func sceneDidBecomeActive()
    func sceneWillResignActive()
}

// MARK: - RealSystemEventsHandler

struct RealSystemEventsHandler: SystemEventsHandler {
    let container: DIContainer

    private let cancelBag = CancelBag()

    init(container: DIContainer) {
        self.container = container
    }

    func sceneDidBecomeActive() {
        container.appState[\.system.isActive] = true
        // TODO: restore cart
    }

    func sceneWillResignActive() {
        // TODO: save cart
        container.appState[\.system.isActive] = false
    }
}
