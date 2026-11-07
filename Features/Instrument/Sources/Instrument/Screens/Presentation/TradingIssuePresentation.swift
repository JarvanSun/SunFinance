//
//  TradingIssuePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import Foundation

extension TradingIssue {
    var title: LocalizedStringResource {
        switch self {
        case .offline: .init("trading.failure.offline.title", bundle: .module)
        case .serviceUnavailable: .init("trading.failure.service.title", bundle: .module)
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .offline: .init("trading.failure.offline.message", bundle: .module)
        case .serviceUnavailable: .init("trading.failure.service.message", bundle: .module)
        }
    }

    var placementMessage: LocalizedStringResource {
        switch self {
        case .offline: .init("trading.review.placeFailed.offline", bundle: .module)
        case .serviceUnavailable: .init("trading.review.placeFailed.service", bundle: .module)
        }
    }

    var image: FinanceImage {
        switch self {
        case .offline: .offline
        case .serviceUnavailable: .warning
        }
    }
}
