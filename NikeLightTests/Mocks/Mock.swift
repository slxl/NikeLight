//
//  Mock.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

@testable import NikeLight
import Testing

// MARK: - Mock

protocol Mock {
    associatedtype Action: Equatable
    var actions: MockActions<Action> { get }

    func register(_ action: Action)
    func verify(sourceLocation: SourceLocation)
}

extension Mock {
    func register(_ action: Action) {
        actions.register(action)
    }

    func verify(sourceLocation: SourceLocation = #_sourceLocation) {
        actions.verify(sourceLocation: sourceLocation)
    }
}

// MARK: - MockActions

final class MockActions<Action> where Action: Equatable {
    let expected: [Action]
    var factual: [Action] = []

    init(expected: [Action]) {
        self.expected = expected
    }

    fileprivate func register(_ action: Action) {
        factual.append(action)
    }

    fileprivate func verify(sourceLocation: SourceLocation) {
        let factualNames = factual.map { "." + String(describing: $0) }
        let expectedNames = expected.map { "." + String(describing: $0) }
        let name = name
        #expect(factual == expected, "\(name)\n\nExpected:\n\n\(expectedNames)\n\nReceived:\n\n\(factualNames)", sourceLocation: sourceLocation)
    }

    private var name: String {
        let fullName = String(describing: self)
        let nameComponents = fullName.components(separatedBy: ".")
        return nameComponents.dropLast().last ?? fullName
    }
}
