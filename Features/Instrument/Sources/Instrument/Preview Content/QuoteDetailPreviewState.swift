//
//  QuoteDetailPreviewState.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

enum QuoteDetailPreviewState: String, CaseIterable, CustomStringConvertible {
    case content
    case notHeld
    case loading
    case offline
    case chartUnavailable
    case german

    var description: String { rawValue }

    var detailError: MarketDataError? {
        switch self {
        case .offline: .offline
        case .content, .notHeld, .loading, .chartUnavailable, .german: nil
        }
    }

    var historyError: MarketDataError? {
        switch self {
        case .chartUnavailable: .server(statusCode: 503)
        case .content, .notHeld, .loading, .offline, .german: nil
        }
    }

    var isHolding: Bool {
        switch self {
        case .notHeld: false
        case .content, .loading, .offline, .chartUnavailable, .german: true
        }
    }

    var delay: Duration {
        switch self {
        case .loading: .seconds(3_600)
        case .content, .notHeld, .offline, .chartUnavailable, .german: .zero
        }
    }

    var locale: Locale {
        switch self {
        case .german: .init(identifier: "de_DE")
        case .content, .notHeld, .loading, .offline, .chartUnavailable: .init(identifier: "en_US")
        }
    }
}
#endif
