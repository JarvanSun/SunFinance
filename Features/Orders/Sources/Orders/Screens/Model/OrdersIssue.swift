//
//  OrdersIssue.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum OrdersIssue: Equatable, Sendable {
    case offline
    case serviceUnavailable

    init(_ error: BrokerageError) {
        switch error {
        case .offline:
            self = .offline
        case .server, .decoding, .cancelled:
            self = .serviceUnavailable
        }
    }
}
