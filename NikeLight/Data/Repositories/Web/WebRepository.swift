//
//  APIClient.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 17/04/2025.
//

// MARK: - APIClient

import Combine
import Foundation

// MARK: - ApiModel

enum ApiModel {}

// MARK: - WebRepository

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {
    func call<Value, Decoder>(
        endpoint: APICall,
        decoder: Decoder = JSONDecoder(),
        httpCodes: HTTPCodes = .success
    ) async throws -> Value
        where Value: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
        let request = try endpoint.urlRequest(baseURL: baseURL)
        let (data, response) = try await session.data(for: request)
        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw APIError.unexpectedResponse
        }
        guard httpCodes.contains(code) else {
            throw APIError.httpCode(code)
        }
        do {
            return try decoder.decode(Value.self, from: data)
        } catch {
            throw APIError.unexpectedResponse
        }
    }
}

typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}
