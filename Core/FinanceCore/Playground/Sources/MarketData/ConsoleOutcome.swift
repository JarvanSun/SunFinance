//
//  ConsoleOutcome.swift
//  FinanceCorePlayground
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

enum ConsoleOutcome: Sendable {
    case idle
    case loading
    case loaded([StockQuote], elapsed: Duration)
    case searched([SymbolMatch], elapsed: Duration)
    case failed(MarketDataError)
}
