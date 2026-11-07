//
//  WatchlistPreviewState.swift
//  Watchlist
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

enum WatchlistPreviewState: String, CaseIterable, CustomStringConvertible {
    case content
    case loading
    case empty
    case offline
    case serviceUnavailable
    case search
    case noSearchResults
    case searchUnavailable
    case german

    var description: String { rawValue }

    var result: Result<[StockQuote], MarketDataError> {
        switch self {
        case .empty:
            .success([])
        case .offline:
            .failure(.offline)
        case .serviceUnavailable:
            .failure(.server(statusCode: 503))
        case .content, .loading, .search, .noSearchResults, .searchUnavailable, .german:
            .success(PreviewObjectPool().quotes)
        }
    }

    var delay: Duration {
        switch self {
        case .loading:
            .seconds(3_600)
        case .content, .empty, .offline, .serviceUnavailable, .search, .noSearchResults,
            .searchUnavailable, .german:
            .zero
        }
    }

    var searchText: String {
        switch self {
        case .search:
            "S"
        case .noSearchResults:
            "Volkswagen"
        case .searchUnavailable:
            "Tesla"
        case .content, .loading, .empty, .offline, .serviceUnavailable, .german:
            ""
        }
    }

    var searchResult: Result<[SymbolMatch], MarketDataError> {
        switch self {
        case .searchUnavailable:
            .failure(.offline)
        case .content, .loading, .empty, .offline, .serviceUnavailable, .search, .noSearchResults,
            .german:
            .success(PreviewObjectPool().symbolMatches)
        }
    }

    var locale: Locale {
        switch self {
        case .german:
            Locale(identifier: "de_DE")
        case .content, .loading, .empty, .offline, .serviceUnavailable, .search, .noSearchResults,
            .searchUnavailable:
            Locale(identifier: "en_US")
        }
    }
}
#endif
