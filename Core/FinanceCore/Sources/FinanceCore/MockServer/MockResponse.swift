//
//  MockResponse.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct MockResponse: Equatable, Sendable {
    let statusCode: Int
    let body: Data

    init(status: HTTPStatus, body: Data = Data()) {
        statusCode = status.rawValue
        self.body = body
    }

    static func json(_ value: some Encodable, status: HTTPStatus = .ok) throws -> Self {
        .init(status: status, body: try JSONEncoder.backend.encode(value))
    }

    static let badRequest = Self(status: .badRequest)
    static let notFound = Self(status: .notFound)
    static let internalError = Self(status: .internalServerError)
    static let serviceUnavailable = Self(status: .serviceUnavailable)
}
