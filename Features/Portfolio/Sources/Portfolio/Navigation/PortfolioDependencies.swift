//
//  PortfolioDependencies.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore

public struct PortfolioDependencies {
    let accountProvider: any AccountProviding
    let positionProvider: any PositionProviding
    let historyProvider: any PortfolioHistoryProviding
    let tracker: any AnalyticsTracking
    let quoteDetail: FeatureEntry<TickerSymbol>
    let orderTicket: FeatureEntry<TradeIntent>
    let refreshInterval: Duration

    public init(
        accountProvider: some AccountProviding,
        positionProvider: some PositionProviding,
        historyProvider: some PortfolioHistoryProviding,
        tracker: some AnalyticsTracking,
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

    func makeViewModel(router: some PortfolioRouting) -> PortfolioViewModel {
        PortfolioViewModel(
            accountProvider: accountProvider,
            positionProvider: positionProvider,
            historyProvider: historyProvider,
            router: router,
            tracker: tracker,
            refreshInterval: refreshInterval
        )
    }
}
