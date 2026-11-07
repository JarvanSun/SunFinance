//
//  QuoteDetailDependencies.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

public struct QuoteDetailDependencies {
    let symbol: TickerSymbol
    let detailProvider: any QuoteDetailProviding
    let historyProvider: any PriceHistoryProviding
    let positionProvider: any PositionProviding
    let orderProvider: any OrderProviding
    let tracker: any AnalyticsTracking

    private let makeOrderTicket: (TradeIntent) -> TradingDependencies

    public init(
        symbol: TickerSymbol,
        detailProvider: some QuoteDetailProviding,
        historyProvider: some PriceHistoryProviding,
        positionProvider: some PositionProviding,
        orderProvider: some OrderProviding,
        tracker: some AnalyticsTracking,
        orderTicket: @escaping (TradeIntent) -> TradingDependencies
    ) {
        self.symbol = symbol
        self.detailProvider = detailProvider
        self.historyProvider = historyProvider
        self.positionProvider = positionProvider
        self.orderProvider = orderProvider
        self.tracker = tracker
        makeOrderTicket = orderTicket
    }

    func makeViewModel(router: some QuoteDetailRouting) -> QuoteDetailViewModel {
        QuoteDetailViewModel(
            symbol: symbol,
            detailProvider: detailProvider,
            historyProvider: historyProvider,
            positionProvider: positionProvider,
            orderProvider: orderProvider,
            router: router,
            tracker: tracker
        )
    }

    func orderTicket(for intent: TradeIntent) -> TradingDependencies {
        makeOrderTicket(intent)
    }
}
