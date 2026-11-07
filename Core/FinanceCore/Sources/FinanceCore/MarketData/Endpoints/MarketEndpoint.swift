//
//  MarketEndpoint.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore

enum MarketEndpoint: Equatable, Sendable {
    case quotes
    case quoteDetail(TickerSymbol)
    case priceHistory(TickerSymbol)
    case symbolSearch

    var path: [String] {
        switch self {
        case .quotes: [version, MarketPathSegment.quotes.rawValue]
        case .quoteDetail(let symbol):
            [version, MarketPathSegment.symbols.rawValue, symbol.rawValue]
        case .priceHistory(let symbol):
            [
                version, MarketPathSegment.symbols.rawValue, symbol.rawValue,
                MarketPathSegment.history.rawValue,
            ]
        case .symbolSearch: [version, MarketPathSegment.search.rawValue]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .quotes, .quoteDetail, .priceHistory, .symbolSearch: .get
        }
    }

    init?(path: [String], method: HTTPMethod) {
        let endpoint = MarketEndpoint(matching: path)
        guard let endpoint, endpoint.method == method else { return nil }

        self = endpoint
    }
}

private extension MarketEndpoint {
    var version: String { APIVersion.v1.rawValue }

    init?(matching path: [String]) {
        let symbolsPrefix = [APIVersion.v1.rawValue, MarketPathSegment.symbols.rawValue]
        switch path {
        case MarketEndpoint.quotes.path:
            self = .quotes
        case MarketEndpoint.symbolSearch.path:
            self = .symbolSearch
        case let path where path.count == 3 && path.starts(with: symbolsPrefix):
            self = .quoteDetail(.init(rawValue: path[2]))
        case let path where path.count == 4 && path.starts(with: symbolsPrefix):
            let symbol = TickerSymbol(rawValue: path[2])
            guard path == MarketEndpoint.priceHistory(symbol).path else { return nil }

            self = .priceHistory(symbol)
        default:
            return nil
        }
    }
}
