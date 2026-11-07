//
//  PortfolioHistoryTests.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import Testing

@testable import FinanceCore

struct PortfolioHistoryTests {
    @Test func initThenMapsRangeAndPoints() throws {
        // When
        let history = try PortfolioHistory(dto(range: "1M"))

        // Then
        #expect(history.range == .month)
        #expect(history.points.map(\.value) == [Money(100, .eur), Money(110, .eur)])
    }

    @Test func initWhenRangeIsUnknownThenThrowsDecoding() {
        // When
        let result = Result { () throws(BrokerageError) in try PortfolioHistory(dto(range: "2M")) }

        // Then
        #expect(result.failure == .decoding)
    }
}

private extension PortfolioHistoryTests {
    func dto(range: String) -> PortfolioHistoryResponseDTO {
        PortfolioHistoryResponseDTO(
            range: range,
            points: [
                ValuePointDTO(date: Date(timeIntervalSince1970: 0), value: .init(euros: 100)),
                ValuePointDTO(date: Date(timeIntervalSince1970: 60), value: .init(euros: 110)),
            ]
        )
    }
}
