//
//  MockedSystemEventsHandler.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

import Foundation
@testable import NikeLight
import UIKit

// MARK: - SystemEventsHandler

final class MockedSystemEventsHandler: Mock, SystemEventsHandler {
    enum Action: Equatable {
        case becomeActive
        case resignActive
    }

    var actions = MockActions<Action>(expected: [])

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }

    func sceneDidBecomeActive() {
        register(.becomeActive)
    }

    func sceneWillResignActive() {
        register(.resignActive)
    }
}
