//
//  MockLedgerTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct MockLedgerTests {
    let exchange = MockExchange()

    @Test func seededWhenOpenedThenHoldsStartingCashAndHistory() {
        // When
        let ledger = MockLedger.seeded(at: TradingClock.tuesdayAfternoon, exchange: exchange)
        let holdings = ledger.book.holdings(asOf: TradingClock.tuesdayAfternoon)

        // Then
        #expect(abs(ledger.cash - 10_000) < Decimal(string: "0.0001")!)
        #expect(Set(holdings.filter(\.isOpen).map(\.symbol)) == ["AAPL", "SAP", "NVDA", "ALV"])
        #expect(holdings.filter { !$0.isOpen }.map(\.symbol) == ["KO"])
        #expect(holdings.first { $0.symbol == "SAP" }?.quantity == 15)
        #expect(ledger.fills.allSatisfy { $0.date < TradingClock.tuesdayAfternoon })
    }

    @Test func seededThenCashEntriesAddUpToTheCash() {
        // When
        let ledger = MockLedger.seeded(at: TradingClock.tuesdayAfternoon, exchange: exchange)

        // Then
        #expect(ledger.cashEntries.reduce(Decimal.zero) { $0 + $1.amount } == ledger.cash)
        #expect(ledger.cashEntries.count == ledger.fills.count + 1)
    }

    @Test func bookWhenFillIsBookedThenCashAndEntryMoveByItsCashEffect() {
        // Given
        var ledger = makeLedger(cash: 1_000)
        let fill = LedgerFill.make(.buy, 2, at: 100)

        // When
        ledger.book(fill)

        // Then
        #expect(ledger.cash == 799)
        #expect(ledger.fills == [fill])
        #expect(ledger.cashEntries.map(\.amount) == [-201])
    }

    @Test func bookWhenDepositIsBookedThenCashGrows() {
        // Given
        var ledger = makeLedger(cash: 0)

        // When
        ledger.book(deposit: 500, at: Date(timeIntervalSince1970: 0))

        // Then
        #expect(ledger.cash == 500)
        #expect(ledger.cashEntries.map(\.amount) == [500])
    }
}

private extension MockLedgerTests {
    func makeLedger(cash: Decimal) -> MockLedger {
        MockLedger(
            cash: cash,
            orders: [],
            fills: [],
            cashEntries: [],
            idempotencyKeys: [:],
            settledUntil: Date(timeIntervalSince1970: 0)
        )
    }
}
