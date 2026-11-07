//
//  PriceHistoryChangeTests.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Instrument

struct PriceHistoryChangeTests {
    @Test func changeThenStartsAtTheBaseline() {
        // Given / When
        let change = PriceHistory.dummyAppleDay.change(to: 110)

        // Then
        #expect(change == PriceChange(start: Money(100, .usd), end: Money(110, .usd)))
    }

    @Test(arguments: [nil, 0] as [Decimal?])
    func changeWhenThereIsNoBaselineThenIsNil(baseline: Decimal?) {
        // Given
        let history = PriceHistory(
            symbol: "AAPL",
            range: .day,
            currency: .usd,
            baseline: baseline,
            candles: []
        )

        // Then
        #expect(history.change(to: 110) == nil)
    }
}
