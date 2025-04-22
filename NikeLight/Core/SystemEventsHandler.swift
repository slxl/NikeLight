//
//  SystemEventsHandler.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Combine
import UIKit

// MARK: - SystemEventsHandler

/// SystemEventsHandler during intial system design supposed to be used to save/restore cart on didBecomeActive/willResignActive events
/// but cart ended up being saved after every mutation so its state is always up to date
/// Kept for potential usage in the future

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
    }

    func sceneWillResignActive() {
        container.appState[\.system.isActive] = false
    }
}
