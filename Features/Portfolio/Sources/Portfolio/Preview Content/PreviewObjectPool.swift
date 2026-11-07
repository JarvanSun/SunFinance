//
//  PreviewObjectPool.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import DesignSystem
import FinanceCore
import Foundation
import SwiftUI

struct PreviewObjectPool {
    func portfolioDependencies() -> PortfolioDependencies {
        let services = PreviewBrokerage()
        return PortfolioDependencies(
            accountProvider: services,
            positionProvider: services,
            historyProvider: services,
            tracker: PreviewAnalyticsTracker(),
            quoteDetail: FeatureEntry { Text(verbatim: "Quote detail \($0.rawValue)") },
            orderTicket: FeatureEntry {
                Text(verbatim: "Order ticket \($0.side) \($0.symbol.rawValue)")
            }
        )
    }

    func portfolioViewModel(_ state: PortfolioPreviewState) -> PortfolioViewModel {
        let services = PreviewBrokerage(
            isEmpty: state.isEmpty,
            failure: state.failure,
            delay: state.delay
        )
        return PortfolioViewModel(
            accountProvider: services,
            positionProvider: services,
            historyProvider: services,
            router: PreviewPortfolioRouter(),
            tracker: PreviewAnalyticsTracker(),
            refreshInterval: .seconds(3_600)
        )
    }

    nonisolated func position(
        _ symbol: TickerSymbol,
        quantity: Decimal,
        value: Decimal,
        gain: Decimal
    ) -> Position {
        let cost = value - gain
        return Position(
            symbol: symbol,
            quantity: quantity,
            price: Money(value / max(quantity, 1), .eur),
            averageCost: Money(cost / max(quantity, 1), .eur),
            averageLocalCost: Money(cost / max(quantity, 1), .eur),
            costBasis: Money(cost, .eur),
            marketValue: Money(value, .eur),
            unrealizedGain: Money(gain, .eur),
            unrealizedGainPercent: cost == 0 ? 0 : gain / cost * 100,
            realizedGain: Money(quantity == 0 ? gain : 0, .eur),
            todayGain: Money(gain / 20, .eur),
            currencyEffect: Money(0, .eur),
            totalReturn: Money(gain, .eur),
            totalReturnPercent: cost == 0 ? 0 : gain / cost * 100
        )
    }
}
#endif
