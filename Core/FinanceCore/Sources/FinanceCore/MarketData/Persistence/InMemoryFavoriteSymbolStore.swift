//
//  InMemoryFavoriteSymbolStore.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

public final class InMemoryFavoriteSymbolStore: FavoriteSymbolStoring {
    public private(set) var favoriteSymbols: Set<TickerSymbol>

    public init(favoriteSymbols: Set<TickerSymbol> = []) {
        self.favoriteSymbols = favoriteSymbols
    }

    public func save(_ symbols: Set<TickerSymbol>) {
        favoriteSymbols = symbols
    }
}
