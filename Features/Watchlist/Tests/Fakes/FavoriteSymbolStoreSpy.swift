//
//  FavoriteSymbolStoreSpy.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore

final class FavoriteSymbolStoreSpy: FavoriteSymbolStoring {
    let favoriteSymbols: Set<TickerSymbol>

    private(set) var savedFavoriteSymbols: [Set<TickerSymbol>] = []

    init(favoriteSymbols: Set<TickerSymbol> = []) {
        self.favoriteSymbols = favoriteSymbols
    }

    func save(_ symbols: Set<TickerSymbol>) {
        savedFavoriteSymbols.append(symbols)
    }
}
