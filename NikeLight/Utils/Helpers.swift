//
//  Helpers.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Combine
import Foundation

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}

extension Result {
    var isSuccess: Bool {
        switch self {
        case .success:
            return true

        case .failure:
            return false
        }
    }
}
