//
//  AppDelegate.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import Combine
import Foundation
import SwiftUI
import UIKit

// MARK: - AppDelegate

@MainActor
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private lazy var environment = AppEnvironment.bootstrap()
    private var systemEventsHandler: SystemEventsHandler { environment.systemEventsHandler }

    var rootView: some View {
        environment.rootView
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont(name: "Futura-CondensedExtraBold", size: 24)! // swiftlint:disable:this force_unwrapping
        ]

        UINavigationBar.appearance().tintColor = UIColor.black

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        SceneDelegate.register(systemEventsHandler)

        return config
    }
}

// MARK: - SceneDelegate

@MainActor
final class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {
    private static var systemEventsHandler: SystemEventsHandler?
    private var systemEventsHandler: SystemEventsHandler? { Self.systemEventsHandler }

    static func register(_ systemEventsHandler: SystemEventsHandler?) {
        Self.systemEventsHandler = systemEventsHandler
    }

    func sceneDidBecomeActive(_: UIScene) {
        systemEventsHandler?.sceneDidBecomeActive()
    }

    func sceneWillResignActive(_: UIScene) {
        systemEventsHandler?.sceneWillResignActive()
    }
}
