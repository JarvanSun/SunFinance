//
//  SymbolSearcherSpy.swift
//  WatchlistTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Synchronization

final class SymbolSearcherSpy: SymbolSearching {
    private let result: Result<[SymbolMatch], MarketDataError>
    private let recordedQueries = Mutex<[String]>([])

    var queries: [String] {
        recordedQueries.withLock { $0 }
    }

    init(result: Result<[SymbolMatch], MarketDataError> = .success([])) {
        self.result = result
    }

    func symbols(matching query: String) async throws(MarketDataError) -> [SymbolMatch] {
        recordedQueries.withLock { $0.append(query) }
        return try result.get()
    }
}
