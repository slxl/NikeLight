//
//  NikeLightApp.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import SwiftUI

// MARK: - NikeLightApp

@main
struct NikeLightApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    var body: some Scene {
        WindowGroup {
            appDelegate.rootView
                .tint(.black)
        }
    }
}

extension AppEnvironment {
    var rootView: some View {
        VStack {
            if isRunningTests {
                Text("Running unit tests")
            } else {
                RootView()
                    .modifier(RootViewAppearance())
                    .modelContainer(modelContainer)
                    .inject(diContainer)

                if modelContainer.isStub {
                    Text("⚠️ There is an issue with local database")
                        .font(.caption2)
                }
            }
        }
    }
}
