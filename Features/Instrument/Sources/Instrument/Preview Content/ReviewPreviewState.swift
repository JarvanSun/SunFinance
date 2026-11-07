//
//  ReviewPreviewState.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

enum ReviewPreviewState: String, CaseIterable, CustomStringConvertible {
    case dollarStock
    case german
    case rejected
    case loading
    case offline

    var description: String { rawValue }

    var rejection: OrderRejection? {
        switch self {
        case .rejected: .insufficientCash
        case .dollarStock, .german, .loading, .offline: nil
        }
    }

    var failure: BrokerageError? {
        switch self {
        case .offline: .offline
        case .dollarStock, .german, .rejected, .loading: nil
        }
    }

    var delay: Duration {
        switch self {
        case .loading: .seconds(3_600)
        case .dollarStock, .german, .rejected, .offline: .zero
        }
    }

    var locale: Locale {
        switch self {
        case .german: .init(identifier: "de_DE")
        case .dollarStock, .rejected, .loading, .offline: .init(identifier: "en_US")
        }
    }
}
#endif
