//
//  UserDefaultsFavoriteSymbolStore.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public final class UserDefaultsFavoriteSymbolStore: FavoriteSymbolStoring {
    private enum StorageKey: String {
        case favoriteSymbols = "marketData.favoriteSymbols"
    }

    public private(set) var favoriteSymbols: Set<TickerSymbol>

    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let rawValues = defaults.stringArray(forKey: StorageKey.favoriteSymbols.rawValue) ?? []
        favoriteSymbols = Set(rawValues.map(TickerSymbol.init(rawValue:)))
    }

    public func save(_ symbols: Set<TickerSymbol>) {
        favoriteSymbols = symbols
        defaults.set(symbols.map(\.rawValue).sorted(), forKey: StorageKey.favoriteSymbols.rawValue)
    }
}
