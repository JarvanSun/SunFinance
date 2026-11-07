//
//  PriceHistoryRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

struct PriceHistoryRequest: APIRequest {
    typealias Response = PriceHistoryResponseDTO

    let symbol: TickerSymbol
    let range: HistoryRange

    var path: [String] { MarketEndpoint.priceHistory(symbol).path }

    var method: HTTPMethod { MarketEndpoint.priceHistory(symbol).method }

    var queryItems: [URLQueryItem] {
        [.init(name: MarketQueryKey.range.rawValue, value: range.rawValue)]
    }
}
