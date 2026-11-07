//
//  MarketDataError.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public enum MarketDataError: Error, Equatable, Sendable {
    case offline
    case server(statusCode: Int)
    case decoding
    case cancelled

    init(_ failure: BackendFailure) {
        switch failure {
        case .offline:
            self = .offline
        case .server(let statusCode):
            self = .server(statusCode: statusCode)
        case .decoding:
            self = .decoding
        case .cancelled:
            self = .cancelled
        }
    }
}
