//
//  TicketHeaderPresentationTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct TicketHeaderPresentationTests {
    @Test func holdingsTextWhenBuyingThenShowsBuyingPower() {
        // When
        let text = makeContext(heldShares: 15).holdingsText(for: .buy)

        // Then
        #expect(text.key == "trading.header.buyingPower %@")
    }

    @Test(arguments: [
        (Decimal(1), "You own 1 share"),
        (Decimal(string: "2.5")!, "You own 2.5 shares"),
    ])
    func holdingsTextWhenSellingThenCountsTheSharesInPlural(shares: Decimal, expected: String) {
        // Given
        var text = makeContext(heldShares: shares).holdingsText(for: .sell)
        text.locale = Locale(identifier: "en_US")

        // When
        let resolved = String(localized: text)

        // Then
        #expect(text.key == "trading.header.held %@ %lf")
        #expect(resolved == expected)
    }

    @Test(arguments: [(true, false), (false, true)])
    func marketNoticeThenShowsOnlyWhileClosed(isMarketOpen: Bool, hasNotice: Bool) {
        // When
        let notice = makeContext(heldShares: 0, isMarketOpen: isMarketOpen).marketNotice

        // Then
        #expect((notice != nil) == hasNotice)
    }

    @Test func priceThenReadsTheQuote() {
        // When
        let context = makeContext(heldShares: 0)

        // Then
        #expect(context.priceValue == 200)
    }
}

private extension TicketHeaderPresentationTests {
    func makeContext(heldShares: Decimal, isMarketOpen: Bool = true) -> TicketContext {
        let quote = StockQuote(
            symbol: "AAPL",
            companyName: "Apple Inc.",
            price: Money(200, .usd),
            changePercent: 1,
            marketCap: Money(1, .usd),
            isMarketOpen: isMarketOpen
        )
        return TicketContext(quote: quote, buyingPower: Money(1_000, .eur), heldShares: heldShares)
    }
}
