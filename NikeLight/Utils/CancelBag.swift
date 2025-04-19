//
//  CancelBag.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//
import Combine

final class CancelBag {
    fileprivate(set) var subscriptions = [any Cancellable]()
    private let equalToAny: Bool
    
    init(equalToAny: Bool = false) {
        self.equalToAny = equalToAny
    }
    
    func cancel() {
        subscriptions.removeAll()
    }
    
    func isEqual(to other: CancelBag) -> Bool {
        other === self || other.equalToAny || self.equalToAny
    }
}

extension Cancellable {
    
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.append(self)
    }
}

extension Task: @retroactive Cancellable { }
