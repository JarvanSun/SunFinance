//
//  WatchlistSymbolStoring.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

@MainActor
public protocol WatchlistSymbolStoring: AnyObject {
    var symbols: [TickerSymbol] { get }

    func save(_ symbols: [TickerSymbol])
}
