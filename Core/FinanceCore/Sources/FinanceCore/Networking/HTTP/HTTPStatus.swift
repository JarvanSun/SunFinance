//
//  HTTPStatus.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

enum HTTPStatus: Int, Sendable {
    case ok = 200
    case created = 201
    case badRequest = 400
    case notFound = 404
    case internalServerError = 500
    case serviceUnavailable = 503
}
