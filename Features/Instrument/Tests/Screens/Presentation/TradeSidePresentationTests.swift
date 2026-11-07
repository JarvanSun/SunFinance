//
//  TradeSidePresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct TradeSidePresentationTests {
    @Test(arguments: [
        (TradeSide.buy, "buy"),
        (.sell, "sell"),
    ])
    func titlesThenFollowTheSide(side: TradeSide, name: String) {
        #expect(side.segmentTitle.key == "trading.side.\(name)")
        #expect(side.ticketTitle(for: "AAPL").key == "trading.ticket.title.\(name) %@")
        #expect(side.limitFieldTitle.key == "trading.limit.field.\(name)")
        #expect(side.triggerPriceFieldTitle.key == "trading.trigger.price.field.\(name)")
        #expect(side.estimateTitle.key == "trading.estimate.total.\(name)")
        #expect(side.totalRowTitle.key == "trading.review.row.total.\(name)")
        #expect(side.slideTitle.key == "trading.review.slide.\(name)")
    }

    @Test(arguments: [
        (
            TradeSide.buy, "quoteDetail.trade.buy", InstrumentAccessibility.buyButton,
            FinanceColor.accent
        ),
        (.sell, "quoteDetail.trade.sell", .sellButton, .loss),
    ])
    func presentationThenNamesAndColorsTheSide(
        side: TradeSide,
        titleKey: String,
        identifier: InstrumentAccessibility,
        fill: FinanceColor
    ) {
        #expect(side.actionTitle.key == titleKey)
        #expect(side.accessibilityIdentifier == identifier)
        #expect(side.fill == fill)
    }
}
