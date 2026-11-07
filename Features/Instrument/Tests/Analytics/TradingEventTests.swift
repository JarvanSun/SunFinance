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
        (OrderDraft.dummy(), "market", "now"),
        (.dummy(execution: .limit(1)), "limit", "now"),
        (.dummy(trigger: .priceAtOrAbove(1)), "stop", "price"),
        (.dummy(execution: .limit(1), trigger: .priceAtOrBelow(1)), "stop_limit", "price"),
        (.dummy(trigger: .at(Date.dummyNow)), "market", "time"),
    ])
    func orderReviewedThenDescribesTypeAndTrigger(
        draft: OrderDraft,
        orderType: String,
        trigger: String
    ) {
        // Given / When
        let parameters = TradingEvent.orderReviewed(draft).parameters

        // Then
        #expect(parameters[.orderType] == .text(orderType))
        #expect(parameters[.trigger] == .text(trigger))
    }

    @Test func orderPlacedThenCarriesStatusButNoSize() {
        // Given / When
        let event = TradingEvent.orderPlaced(.dummy(status: .filled))

        // Then
        #expect(event.name == .init("trading_order_placed"))
        #expect(event.parameters[.status] == .text("filled"))
        #expect(Set(event.parameters.keys) == [.symbol, .side, .orderType, .trigger, .status])
    }

    @Test func ticketOpenedThenNamesTheSource() {
        // Given / When
        let event = TradingEvent.ticketOpened(
            TradeIntent(symbol: "SAP", side: .sell, source: .position)
        )

        // Then
        #expect(event.parameters[.source] == .text("position"))
    }
}
