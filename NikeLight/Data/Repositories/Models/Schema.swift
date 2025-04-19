//
//  DBModel.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import SwiftData

// MARK: - DBModel

enum DBModel {}

extension Schema {
    private static var actualVersion: Schema.Version = Version(1, 0, 0)

    static var appSchema: Schema {
        Schema([
            DBModel.CartItem.self
        ], version: actualVersion)
    }
}
