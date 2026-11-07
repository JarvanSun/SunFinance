//
//  QuoteDetailIssue.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum QuoteDetailIssue: Equatable, Sendable {
    case offline
    case serviceUnavailable
    case unreadableData

    init(_ error: MarketDataError) {
        switch error {
        case .offline:
            self = .offline
        case .server, .cancelled:
            self = .serviceUnavailable
        case .decoding:
            self = .unreadableData
        }
    }

    init(_ error: BrokerageError) {
        switch error {
        case .offline:
            self = .offline
        case .server, .cancelled:
            self = .serviceUnavailable
        case .decoding:
            self = .unreadableData
        }
    }
}
