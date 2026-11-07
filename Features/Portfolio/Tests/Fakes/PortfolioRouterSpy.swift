//
//  PortfolioRouterSpy.swift
//  PortfolioTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

@testable import Portfolio

final class PortfolioRouterSpy: PortfolioRouting {
    private(set) var quoteDetails: [TickerSymbol] = []
    private(set) var tickets: [TradeIntent] = []

    func showQuoteDetail(for symbol: TickerSymbol) {
        quoteDetails.append(symbol)
    }

    func showOrderTicket(for intent: TradeIntent) {
        tickets.append(intent)
    }
}
