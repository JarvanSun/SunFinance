//
//  PortfolioChangeTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Testing

@testable import Portfolio

struct PortfolioChangeTests {
    @Test(arguments: [
        (Decimal(100), Decimal(110), PortfolioChange.known(Money(10, .eur), percent: 10)),
        (200, 150, .known(Money(-50, .eur), percent: -25)),
        (0, 50, .known(Money(50, .eur), percent: 0)),
    ])
    func initThenMeasuresTheChangeFromStartToEnd(
        start: Decimal,
        end: Decimal,
        expected: PortfolioChange
    ) {
        // Given
        let change = PortfolioChange(from: Money(start, .eur), to: Money(end, .eur))

        // Then
        #expect(change == expected)
    }
}
