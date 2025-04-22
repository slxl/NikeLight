//
//  RootViewAppearance.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Combine
import SwiftUI

// MARK: - RootViewAppearance

struct RootViewAppearance: ViewModifier {
    @Environment(\.injected)
    private var injected: DIContainer

    @State private var isActive: Bool = false

    private var stateUpdate: AnyPublisher<Bool, Never> {
        injected.appState.updates(for: \.system.isActive)
    }

    func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? 0 : 10)
            .ignoresSafeArea()
            .onReceive(stateUpdate) { isActive = $0 }
    }
}
