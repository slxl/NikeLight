//
//  TestHelpers.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 21/04/2025.
//

@testable import NikeLight
import SwiftUI
import UIKit.UIColor

// MARK: - UI

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { rendererContext in
            setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

// MARK: - MockError

enum MockError: Swift.Error {
    case valueNotSet
    case codeDataModel
}

extension NSError {
    static var test: NSError {
        return NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test error"])
    }
}

// MARK: - Misc

extension CancelBag {
    static var test: CancelBag {
        return CancelBag(equalToAny: true)
    }
}

// MARK: - TestExpectation

struct TestExpectation {
    private let signal: AsyncStream<Void>.Continuation?
    private let stream: AsyncStream<Void>
    private let expectedCount: Int

    init(expectedCount: Int = 1) {
        precondition(expectedCount > 0)
        self.expectedCount = expectedCount
        var signal: AsyncStream<Void>.Continuation?
        self.stream = AsyncStream<Void> { signal = $0 }
        self.signal = signal
    }

    func fulfill() {
        signal?.yield()
    }

    func fulfillment() async {
        await stream
            .dropFirst(expectedCount - 1)
            .first(where: { _ in true })
    }
}

// MARK: - BindingWithHistory

final class BindingWithHistory<Value> {
    private(set) var binding: Binding<Value>
    private(set) var history: [Value]

    init(value: Value) {
        binding = .constant(value)
        history = [value]
        var value = value
        binding = Binding<Value>(get: {
            value
        }, set: { [weak self] in
            value = $0
            self?.history.append($0)
        })
    }
}
