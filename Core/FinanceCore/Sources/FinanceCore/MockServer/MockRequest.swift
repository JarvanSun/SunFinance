//
//  MockRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

struct MockRequest: Sendable {
    let method: HTTPMethod
    let path: [String]
    let body: Data?
    let date: Date

    private let queryItems: [URLQueryItem]
    private let headers: [String: String]

    init(
        method: HTTPMethod,
        path: [String],
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        date: Date
    ) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
        self.date = date
    }

    func query(_ name: String) -> String? {
        queryItems.first { $0.name == name }?.value
    }

    func header(_ key: HeaderKey) -> String? {
        headers.first { $0.key.caseInsensitiveCompare(key.rawValue) == .orderedSame }?.value
    }
}

extension MockRequest {
    init(_ request: URLRequest, date: Date) {
        let components = request.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        }
        self.init(
            method: request.httpMethod.flatMap(HTTPMethod.init(rawValue:)) ?? .get,
            path: request.url?.pathComponents.filter { $0 != "/" } ?? [],
            queryItems: components?.queryItems ?? [],
            headers: request.allHTTPHeaderFields ?? [:],
            body: request.httpBody,
            date: date
        )
    }

    var isRead: Bool {
        method == .get
    }
}
