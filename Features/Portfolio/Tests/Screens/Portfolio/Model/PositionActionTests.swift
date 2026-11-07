//
//  PositionActionTests.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Testing

@testable import Portfolio

struct PositionActionTests {
    @Test(arguments: [(PositionAction.buyMore, TradeSide.buy), (.sell, .sell)])
    func sideThenMatchesTheAction(action: PositionAction, side: TradeSide) {
        #expect(action.side == side)
    }
}
