//
//  QuotesRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

struct QuotesRequest: APIRequest {
    typealias Response = QuotesResponseDTO

    let symbols: [TickerSymbol]

    var path: [String] { MarketEndpoint.quotes.path }

    var method: HTTPMethod { MarketEndpoint.quotes.method }

    var queryItems: [URLQueryItem] {
        [.init(name: MarketQueryKey.symbols.rawValue, value: joinedSymbols)]
    }
}

private extension QuotesRequest {
    var joinedSymbols: String {
        symbols.map(\.rawValue).joined(separator: ListSeparator.comma.rawValue)
    }
}
