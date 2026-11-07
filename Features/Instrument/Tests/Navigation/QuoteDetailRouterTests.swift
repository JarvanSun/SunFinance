//
//  QuoteDetailRouterTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import SunUserInterface
import Testing

@testable import Instrument

struct QuoteDetailRouterTests {
    @Test func showOrderTicketThenPresentsTheTicketAsSheet() {
        // Given
        let router = makeRouter()
        let intent = TradeIntent(symbol: "AAPL", side: .buy, source: .quoteDetail)

        // When
        router.showOrderTicket(for: intent, onDismiss: {})

        // Then
        #expect(router.presentation?.destination == .orderTicket(intent))
        #expect(router.presentation?.style == .sheet)
        #expect(router.path.isEmpty)
    }

    @Test func presentationWhenTicketClosesThenCallsOnDismissOnce() {
        // Given
        let router = makeRouter()
        var dismissals = 0
        router.showOrderTicket(
            for: TradeIntent(symbol: "AAPL", side: .sell, source: .quoteDetail),
            onDismiss: { dismissals += 1 }
        )

        // When
        router.presentation = nil
        router.presentation = nil

        // Then
        #expect(dismissals == 1)
    }
}

private extension QuoteDetailRouterTests {
    func makeRouter() -> QuoteDetailRouter {
        QuoteDetailRouter(orderTicket: makeDependencies().orderTicket(for:))
    }

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
