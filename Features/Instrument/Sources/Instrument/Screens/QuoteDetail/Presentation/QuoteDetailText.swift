//
//  QuoteDetailText.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum QuoteDetailText {
    static var statisticsTitle: LocalizedStringResource {
        .init("quoteDetail.statistics.title", bundle: .module)
    }

    static var chartUnavailable: LocalizedStringResource {
        .init("quoteDetail.chart.unavailable", bundle: .module)
    }

    static var chartLoading: LocalizedStringResource {
        .init("quoteDetail.chart.loading", bundle: .module)
    }

    static var retry: LocalizedStringResource {
        .init("quoteDetail.placeholder.retry", bundle: .module)
    }

    static var positionTitle: LocalizedStringResource {
        .init("quoteDetail.position.title", bundle: .module)
    }

    static var positionShares: LocalizedStringResource {
        .init("quoteDetail.position.shares", bundle: .module)
    }

    static var positionRealized: LocalizedStringResource {
        .init("quoteDetail.position.realized", bundle: .module)
    }

    static var positionToday: LocalizedStringResource {
        .init("quoteDetail.position.today", bundle: .module)
    }

    static var positionCurrencyEffect: LocalizedStringResource {
        .init("quoteDetail.position.currencyEffect", bundle: .module)
    }

    static var positionSinceBuy: LocalizedStringResource {
        .init("quoteDetail.position.sinceBuy", bundle: .module)
    }

    static var positionSinceBuyPercent: LocalizedStringResource {
        .init("quoteDetail.position.sinceBuyPercent", bundle: .module)
    }

    static func positionBuyIn(_ amount: String) -> LocalizedStringResource {
        .init("quoteDetail.position.buyIn \(amount)", bundle: .module)
    }

    static func positionAverageBuyIn(_ amount: String) -> LocalizedStringResource {
        .init("quoteDetail.position.averageBuyIn \(amount)", bundle: .module)
    }

    static func positionTotalReturn(_ percent: String) -> LocalizedStringResource {
        .init("quoteDetail.position.totalReturnPercent \(percent)", bundle: .module)
    }
}
