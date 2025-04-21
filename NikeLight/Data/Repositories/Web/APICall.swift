//
//  APICall.swift
//  NikeLight
//
//  Created by Slava Khlichkin on 20/04/2025.
//

import Foundation

// MARK: - APICall

protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }

    func body() throws -> Data?
}

extension APICall {
    func urlRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()

        return request
    }
}
