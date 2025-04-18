//
//  CustomFont.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 18/04/2025.
//

import SwiftUI

// MARK: - CustomFont

enum CustomFont {
    // swiftformat:sort
    enum NikeStyle: String {
        case bold = "Futura-Bold"
        case boldCondencedMedium = "Futura-CondensedMedium"
        case boldCondencedExtraBold = "Futura-CondensedExtraBold"
        case medium = "Futura-Medium"
        case regular = "Futura"
    }
}

extension Font {
    static func nike(_ weight: CustomFont.NikeStyle, size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
}
