//
//  Item.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
