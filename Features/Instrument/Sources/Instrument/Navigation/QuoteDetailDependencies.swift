//
//  QuoteDetailDependencies.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

public struct QuoteDetailDependencies {
    let symbol: TickerSymbol
    let detailProvider: QuoteDetailProviding
    let historyProvider: PriceHistoryProviding
    let positionProvider: PositionProviding
    let orderProvider: OrderProviding
    let tracker: AnalyticsTracking

    private let makeOrderTicket: (TradeIntent) -> TradingDependencies

    public init(
        symbol: TickerSymbol,
        detailProvider: QuoteDetailProviding,
        historyProvider: PriceHistoryProviding,
        positionProvider: PositionProviding,
        orderProvider: OrderProviding,
        tracker: AnalyticsTracking,
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

    func makeViewModel(router: QuoteDetailRouting) -> QuoteDetailViewModel {
        .init(
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
