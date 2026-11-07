//
//  MockServer.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

struct MockServer: Sendable {
    private let routes: [MockRoute]
    private let behavior: MockServerBehavior
    private let now: @Sendable () -> Date

    init(
        routes: [MockRoute],
        behavior: MockServerBehavior,
        now: @escaping @Sendable () -> Date = { Date() }
    ) {
        self.routes = routes
        self.behavior = behavior
        self.now = now
    }

    func makeSender() -> RequestSender {
        .init { request in try await respond(to: request) }
    }

    func respond(to urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await Task.sleep(for: randomLatency)
        let request = MockRequest(urlRequest, date: now())
        let response = response(to: request)
        return (response.body, try httpResponse(for: urlRequest, statusCode: response.statusCode))
    }
}

private extension MockServer {
    var contentType: String { "application/json" }

    var randomLatency: Duration {
        let lowerBound = behavior.latency.lowerBound.timeInterval
        let upperBound = behavior.latency.upperBound.timeInterval
        return .seconds(Double.random(in: lowerBound...upperBound))
    }

    func response(to request: MockRequest) -> MockResponse {
        switch (shouldFail(request), routedResponse(to: request)) {
        case (true, _): .init(status: .serviceUnavailable)
        case (false, .some(let response)): response
        case (false, nil): .init(status: .notFound)
        }
    }

    func shouldFail(_ request: MockRequest) -> Bool {
        let failureRate = request.isRead ? behavior.readFailureRate : behavior.writeFailureRate
        return Double.random(in: 0..<1) < failureRate
    }

    func routedResponse(to request: MockRequest) -> MockResponse? {
        do {
            return try firstResponse(to: request)
        } catch {
            return .init(status: .internalServerError)
        }
    }

    func firstResponse(to request: MockRequest) throws -> MockResponse? {
        for route in routes {
            guard let response = try route.response(to: request) else { continue }

            return response
        }
        return nil
    }

    func httpResponse(for request: URLRequest, statusCode: Int) throws -> HTTPURLResponse {
        let response = request.url.flatMap { url in
            HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: [HeaderKey.contentType.rawValue: contentType]
            )
        }
        guard let response else { throw URLError(.badServerResponse) }

        return response
    }
}
