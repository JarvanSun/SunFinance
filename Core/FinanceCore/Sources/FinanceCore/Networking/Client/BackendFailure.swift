//
//  BackendFailure.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

enum BackendFailure: Error, Equatable, Sendable {
    case offline
    case server(statusCode: Int)
    case decoding
    case cancelled

    init(_ error: Error) {
        switch error {
        case let failure as BackendFailure:
            self = failure
        case is CancellationError:
            self = .cancelled
        case let error as URLError where error.isConnectivityFailure:
            self = .offline
        case let error as HTTPError:
            self = .server(statusCode: error.response.statusCode)
        default:
            self = .decoding
        }
    }
}
