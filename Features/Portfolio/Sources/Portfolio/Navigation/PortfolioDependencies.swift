//
//  PortfolioDependencies.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore

public struct PortfolioDependencies {
    let accountProvider: AccountProviding
    let positionProvider: PositionProviding
    let historyProvider: PortfolioHistoryProviding
    let tracker: AnalyticsTracking
    let quoteDetail: FeatureEntry<TickerSymbol>
    let orderTicket: FeatureEntry<TradeIntent>
    let refreshInterval: Duration

    public init(
        accountProvider: AccountProviding,
        positionProvider: PositionProviding,
        historyProvider: PortfolioHistoryProviding,
        tracker: AnalyticsTracking,
        quoteDetail: FeatureEntry<TickerSymbol>,
        orderTicket: FeatureEntry<TradeIntent>,
        refreshInterval: Duration = .seconds(15)
    ) {
        self.accountProvider = accountProvider
        self.positionProvider = positionProvider
        self.historyProvider = historyProvider
        self.tracker = tracker
        self.quoteDetail = quoteDetail
        self.orderTicket = orderTicket
        self.refreshInterval = refreshInterval
    }

    func makeViewModel(router: PortfolioRouting) -> PortfolioViewModel {
        .init(
            accountProvider: accountProvider,
            positionProvider: positionProvider,
            historyProvider: historyProvider,
            router: router,
            tracker: tracker,
            refreshInterval: refreshInterval
        )
    }
}
