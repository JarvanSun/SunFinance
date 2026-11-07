//
//  FavoriteSymbolStoring.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

@MainActor
public protocol FavoriteSymbolStoring: AnyObject {
    var favoriteSymbols: Set<TickerSymbol> { get }

    func save(_ symbols: Set<TickerSymbol>)
}
