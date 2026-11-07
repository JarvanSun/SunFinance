//
//  PortfolioEventTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Portfolio

struct PortfolioEventTests {
    @Test func parametersThenNameCountRangeAndSymbol() {
        #expect(PortfolioEvent.viewed(positionCount: 3).parameters == [.positionCount: .integer(3)])
        #expect(PortfolioEvent.rangeChanged(.year).parameters == [.range: .text("1Y")])
        #expect(PortfolioEvent.positionOpened("SAP").parameters == [.symbol: .text("SAP")])
        #expect(PortfolioEvent.viewed(positionCount: 3).name == .portfolioViewed)
    }
}
