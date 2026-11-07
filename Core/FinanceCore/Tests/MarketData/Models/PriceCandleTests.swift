//
//  PriceCandleTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct PriceCandleTests {
    @Test func initThenMapsEveryField() {
        // Given
        let start = Date(timeIntervalSince1970: 600)
        let dto = CandleDTO(start: start, open: 10, high: 12, low: 9, close: 11, volume: 5)

        // When
        let candle = PriceCandle(dto)

        // Then
        let expected = PriceCandle(start: start, open: 10, high: 12, low: 9, close: 11, volume: 5)
        #expect(candle == expected)
    }
}
