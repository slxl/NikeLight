//
//  CheckoutWebRepository.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 20/04/2025.
//

import Foundation

// MARK: - CheckoutWebRepository

protocol CheckoutWebRepository: WebRepository {
    func simulateCheckout() async throws -> Bool
}

// MARK: - EmptyResponse

struct EmptyResponse: Decodable {}

// MARK: - RealCheckoutWebRepository

struct RealCheckoutWebRepository: CheckoutWebRepository {
    private enum Constants {
        static let pollingInterval: TimeInterval = 3
        static let timeout: TimeInterval = 60 // set shorter time to get higher chances of getting checkout timeout failure
    }

    let session: URLSession
    let baseURL: String

    init(session: URLSession) {
        self.session = session
        self.baseURL = "https://httpbin.org"
    }

    /// Simulates a checkout process by polling an API endpoint at regular intervals.
    /// After each successful API call, it randomly determines whether the checkout has completed.
    /// If a simulated success is detected, the function returns `true`.
    /// Otherwise, it continues polling until the maximum number of attempts is reached.
    ///
    /// - Returns: `true` if the simulated checkout succeeds within the timeout window.
    /// - Throws: `APIError.timeout` if the checkout does not succeed within the allowed number of polling attempts,
    ///           or if an API call fails repeatedly during the polling process.
    ///
    /// The polling interval and timeout duration are defined by `Constants.pollingInterval` and `Constants.timeout`.
    func simulateCheckout() async throws -> Bool {
        let maxAttempts = Int(Constants.timeout / Constants.pollingInterval)

        for attempt in 1 ... maxAttempts {
            do {
                _ = try await call(endpoint: API.checkout) as EmptyResponse

                // Simulate checkout success or failure randomly
                let isCheckoutSuccessful = Bool.random()

                if isCheckoutSuccessful {
                    return true
                }
            } catch {}

            try await Task.sleep(nanoseconds: UInt64(Constants.pollingInterval * 1_000_000_000))
        }

        throw APIError.timeout
    }
}

// MARK: RealCheckoutWebRepository.API

extension RealCheckoutWebRepository {
    enum API {
        case checkout
    }
}

// MARK: - RealCheckoutWebRepository.API + APICall

extension RealCheckoutWebRepository.API: APICall {
    var path: String {
        switch self {
        case .checkout:
            return "/delay/3"
        }
    }

    var method: String {
        "GET"
    }

    var headers: [String: String]? {
        ["Accept": "application/json"]
    }

    func body() throws -> Data? {
        nil
    }
}
