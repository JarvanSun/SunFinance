//
//  PortfolioPreviewState.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

enum PortfolioPreviewState: String, CaseIterable, CustomStringConvertible {
    case content
    case german
    case empty
    case loading
    case offline

    var description: String { rawValue }

    var isEmpty: Bool {
        self == .empty
    }

    var failure: BrokerageError? {
        switch self {
        case .offline:
            .offline
        case .content, .german, .empty, .loading:
            nil
        }
    }

    var delay: Duration {
        switch self {
        case .loading:
            .seconds(3_600)
        case .content, .german, .empty, .offline:
            .zero
        }
    }

    var locale: Locale {
        switch self {
        case .german:
            Locale(identifier: "de_DE")
        case .content, .empty, .loading, .offline:
            Locale(identifier: "en_US")
        }
    }
}
#endif
