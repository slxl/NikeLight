//
//  RoundedCorner.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 19/04/2025.
//

import SwiftUI

// MARK: - RoundedCorner

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        return Path(path.cgPath)
    }
}
