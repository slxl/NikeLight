//
//  AppState.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Combine
import SwiftUI

// MARK: - AppState

struct AppState {
    var routing = ViewRouting()
    var system = System()
}

// MARK: Equatable

extension AppState: Equatable {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.routing == rhs.routing
            && lhs.system == rhs.system
    }
}

// MARK: AppState.ViewRouting

extension AppState {
    struct ViewRouting: Equatable {
        var productsList = ProductListView.Routing()
    }
}

// MARK: AppState.System

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
    }
}
