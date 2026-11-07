//
//  PortfolioIssue.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum PortfolioIssue: Equatable, Sendable {
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
