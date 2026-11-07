//
//  TradingIssue.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum TradingIssue: Equatable, Sendable {
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

    init(_ error: MarketDataError) {
        switch error {
        case .offline:
            self = .offline
        case .server, .decoding, .cancelled:
            self = .serviceUnavailable
        }
    }

    var analyticsReason: String {
        switch self {
        case .offline: "offline"
        case .serviceUnavailable: "service_unavailable"
        }
    }
}
