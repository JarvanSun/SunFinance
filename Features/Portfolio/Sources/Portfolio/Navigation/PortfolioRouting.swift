//
//  PortfolioRouting.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

protocol PortfolioRouting: AnyObject {
    func showQuoteDetail(for symbol: TickerSymbol)
    func showOrderTicket(for intent: TradeIntent)
}
