//
//  PortfolioHistoryProviding.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol PortfolioHistoryProviding: Sendable {
    func portfolioHistory(range: HistoryRange) async throws(BrokerageError) -> PortfolioHistory
}
