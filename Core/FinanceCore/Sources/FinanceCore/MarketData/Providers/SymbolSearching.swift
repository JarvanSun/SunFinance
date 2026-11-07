//
//  SymbolSearching.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public protocol SymbolSearching: Sendable {
    func symbols(matching query: String) async throws(MarketDataError) -> [SymbolMatch]
}
