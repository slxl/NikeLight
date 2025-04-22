//
//  MockedResponse.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

import Foundation
@testable import NikeLight

// MARK: - RequestMocking.MockedResponse

extension RequestMocking {
    struct MockedResponse {
        let url: URL
        let result: Result<Data, Swift.Error>
        let httpCode: HTTPCode
        let headers: [String: String]
        let loadingTime: TimeInterval
        let customResponse: URLResponse?
    }
}

extension RequestMocking.MockedResponse {
    enum Error: Swift.Error {
        case notMockedRequest(URLRequest)
        case responseFactoryFailure
        case mockInitializationFailure
    }

    init<T>(apiCall: APICall, baseURL: String,
            result: Result<T, Swift.Error>,
            httpCode: HTTPCode = 200,
            headers: [String: String] = ["Content-Type": "application/json"],
            loadingTime: TimeInterval = 0.1) throws where T: Encodable {
        guard let url = try apiCall.urlRequest(baseURL: baseURL).url
        else { throw Error.mockInitializationFailure }
        self.url = url
        switch result {
        case let .success(value):
            self.result = try .success(JSONEncoder().encode(value))
        case let .failure(error):
            self.result = .failure(error)
        }
        self.httpCode = httpCode
        self.headers = headers
        self.loadingTime = loadingTime
        customResponse = nil
    }

    init(apiCall: APICall, baseURL: String, customResponse: URLResponse) throws {
        guard let url = try apiCall.urlRequest(baseURL: baseURL).url
        else { throw Error.mockInitializationFailure }
        self.url = url
        result = .success(Data())
        httpCode = 200
        headers = [String: String]()
        loadingTime = 0
        self.customResponse = customResponse
    }

    init(url: URL, result: Result<Data, Swift.Error>) {
        self.url = url
        self.result = result
        httpCode = 200
        headers = [String: String]()
        loadingTime = 0
        customResponse = nil
    }
}
