//
//  TradingEventTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct TradingEventTests {
    @Test(arguments: [
        (OrderDraft.make(), "market", "now"),
        (.make(execution: .limit(1)), "limit", "now"),
        (.make(trigger: .priceAtOrAbove(1)), "stop", "price"),
        (.make(execution: .limit(1), trigger: .priceAtOrBelow(1)), "stop_limit", "price"),
        (.make(trigger: .at(.testNow)), "market", "time"),
    ])
    func orderReviewedThenDescribesTypeAndTrigger(
        draft: OrderDraft,
        orderType: String,
        trigger: String
    ) {
        // When
        let parameters = TradingEvent.orderReviewed(draft).parameters

        // Then
        #expect(parameters[.orderType] == .text(orderType))
        #expect(parameters[.trigger] == .text(trigger))
    }

    @Test func orderPlacedThenCarriesStatusButNoSize() {
        // When
        let event = TradingEvent.orderPlaced(.make(status: .filled))

        // Then
        #expect(event.name == .tradingOrderPlaced)
        #expect(event.parameters[.status] == .text("filled"))
        #expect(Set(event.parameters.keys) == [.symbol, .side, .orderType, .trigger, .status])
    }

    @Test func ticketOpenedThenNamesTheSource() {
        // When
        let event = TradingEvent.ticketOpened(
            TradeIntent(symbol: "SAP", side: .sell, source: .position)
        )

        // Then
        #expect(event.parameters[.source] == .text("position"))
    }
}
