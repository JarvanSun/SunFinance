//
//  QuoteDetailRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore

struct QuoteDetailRequest: APIRequest {
    typealias Response = QuoteDetailResponseDTO

    let symbol: TickerSymbol

    var path: [String] { MarketEndpoint.quoteDetail(symbol).path }

    var method: HTTPMethod { MarketEndpoint.quoteDetail(symbol).method }
}
