//
//  AppState.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Foundation

// MARK: - AppState

struct AppState {
    var system = System()
}

// MARK: Equatable

extension AppState: Equatable {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.system == rhs.system
    }
}

// MARK: AppState.System

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
    }
}
