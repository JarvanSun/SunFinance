//
//  UserDefaultsWatchlistSymbolStore.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public final class UserDefaultsWatchlistSymbolStore: WatchlistSymbolStoring {
    private enum StorageKey: String {
        case watchlistSymbols = "marketData.watchlistSymbols"
    }

    public private(set) var symbols: [TickerSymbol]

    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard, defaultSymbols: [TickerSymbol]) {
        self.defaults = defaults
        symbols = Self.storedSymbols(in: defaults) ?? defaultSymbols
    }

    public func save(_ symbols: [TickerSymbol]) {
        self.symbols = symbols
        defaults.set(symbols.map(\.rawValue), forKey: StorageKey.watchlistSymbols.rawValue)
    }
}

private extension UserDefaultsWatchlistSymbolStore {
    static func storedSymbols(in defaults: UserDefaults) -> [TickerSymbol]? {
        defaults.stringArray(forKey: StorageKey.watchlistSymbols.rawValue)?
            .map(TickerSymbol.init(rawValue:))
    }
}
