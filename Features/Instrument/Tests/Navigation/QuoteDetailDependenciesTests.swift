//
//  QuoteDetailDependenciesTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Instrument

struct QuoteDetailDependenciesTests {
    @Test func makeViewModelThenStartsOnTheOneDayLine() {
        // Given
        let dependencies = makeDependencies()

        // When
        let viewModel = dependencies.makeViewModel(router: QuoteDetailRouterSpy())

        // Then
        #expect(viewModel.range == .day)
        #expect(viewModel.chartStyle == .line)
    }

    @Test func orderTicketThenOpensTheTicketForTheIntent() {
        // Given
        let dependencies = makeDependencies()
        let intent = TradeIntent(symbol: "AAPL", side: .sell, source: .quoteDetail)

        // When
        let ticket = dependencies.orderTicket(for: intent)

        // Then
        #expect(ticket.intent == intent)
    }
}

private extension QuoteDetailDependenciesTests {
    func makeDependencies() -> QuoteDetailDependencies {
        let services = TradingServicesStub()
        let tracker = AnalyticsTrackerSpy()
        return QuoteDetailDependencies(
            symbol: "AAPL",
            detailProvider: MarketDataStub(),
            historyProvider: MarketDataStub(),
            positionProvider: BrokerageStub(),
            orderProvider: BrokerageStub(),
            tracker: tracker,
            orderTicket: { intent in
                TradingDependencies(
                    intent: intent,
                    quoteProvider: services,
                    accountProvider: services,
                    positionProvider: services,
                    previewer: services,
                    placer: services,
                    tracker: tracker
                )
            }
        )
    }
}
