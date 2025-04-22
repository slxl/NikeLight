//
//  WebRepositoryTests.swift
//  UnitTests
//
//  Created by Slava Khlichkin on 21/04/2025.
//

import Combine
import Foundation
@testable import NikeLight
import Testing

// MARK: - WebRepositoryTests

@Suite(.serialized) final class WebRepositoryTests {
    private let sut = TestWebRepository()

    private typealias API = TestWebRepository.API
    typealias Mock = RequestMocking.MockedResponse

    deinit {
        RequestMocking.removeAllMocks()
    }

    @Test func loadSuccess() async throws {
        let data = TestWebRepository.TestData()
        try mock(.test, result: .success(data))
        let result = try await sut.load(.test)
        #expect(result == data)
    }

    @Test func loadParseError() async throws {
        let data = await ApiModel.Product.mockedProducts
        try mock(.test, result: .success(data))

        await #expect(throws: APIError.unexpectedResponse) {
            try await self.sut.load(.test)
        }
    }

    @Test func loadHttpCodeFailure() async throws {
        let data = TestWebRepository.TestData()
        try mock(.test, result: .success(data), httpCode: 500)
        await #expect(throws: APIError.httpCode(500)) {
            try await self.sut.load(.test)
        }
    }

    @Test func loadNetworkingError() async throws {
        let errorRef = NSError.test
        try mock(.test, result: Result<TestWebRepository.TestData, Error>.failure(errorRef))
        do {
            _ = try await sut.load(.test)
            Issue.record("Above should throw")
        } catch {
            let nsError = error as NSError
            #expect(nsError.domain == errorRef.domain)
            #expect(nsError.code == errorRef.code)
        }
    }

    @Test func loadRequestURLError() async {
        await #expect(throws: APIError.invalidURL) {
            try await self.sut.load(.urlError)
        }
    }

    @Test func loadRequestBodyError() async {
        await #expect(throws: TestWebRepository.APIError.fail) {
            try await self.sut.load(.bodyError)
        }
    }

    @Test func loadLoadableError() async {
        await #expect(throws: APIError.invalidURL) {
            try await self.sut.load(.urlError)
        }
    }

    @Test func loadNoHttpCodeError() async throws {
        let response = URLResponse(url: URL(fileURLWithPath: ""),
                                   mimeType: "example", expectedContentLength: 0, textEncodingName: nil)
        let mock = try Mock(apiCall: API.test, baseURL: sut.baseURL, customResponse: response)
        RequestMocking.add(mock: mock)
        await #expect(throws: APIError.unexpectedResponse) {
            try await self.sut.load(.test)
        }
    }

    // MARK: - Helper

    private func mock<T>(_ apiCall: API, result: Result<T, Swift.Error>,
                         httpCode: HTTPCode = 200) throws where T: Encodable {
        let mock = try Mock(apiCall: apiCall, baseURL: sut.baseURL, result: result, httpCode: httpCode)
        RequestMocking.add(mock: mock)
    }
}

private extension TestWebRepository {
    func load(_ api: API) async throws -> TestData {
        try await call(endpoint: api)
    }
}

// MARK: - TestWebRepository.API

extension TestWebRepository {
    enum API: APICall {
        case test
        case urlError
        case bodyError
        case noHttpCodeError

        var path: String {
            if self == .urlError {
                return "\\"
            }
            return "/test/path"
        }

        var method: String { "POST" }
        var headers: [String: String]? { nil }
        func body() throws -> Data? {
            if self == .bodyError { throw APIError.fail }
            return nil
        }
    }
}

// MARK: - TestWebRepository.APIError

extension TestWebRepository {
    enum APIError: Swift.Error, LocalizedError {
        case fail
        var errorDescription: String? { "fail" }
    }
}

// MARK: - TestWebRepository.TestData

extension TestWebRepository {
    struct TestData: Codable, Equatable {
        let string: String
        let integer: Int

        init() {
            string = "some string"
            integer = 42
        }
    }
}
