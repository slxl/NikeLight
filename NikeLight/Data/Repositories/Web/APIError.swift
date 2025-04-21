//
//  APIError.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 20/04/2025.
//

import Foundation

// MARK: - APIError

// swiftformat:sort
enum APIError: Swift.Error, Equatable {
    case httpCode(HTTPCode)
    case imageDeserialization
    case invalidURL
    case timeout
    case unexpectedResponse
}

// MARK: LocalizedError

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"

        case let .httpCode(code):
            return "Unexpected HTTP code: \(code)"

        case .unexpectedResponse:
            return "Unexpected response from the server"

        case .imageDeserialization:
            return "Cannot deserialize image from Data"

        case .timeout:
            return "Timeout error"
        }
    }
}
