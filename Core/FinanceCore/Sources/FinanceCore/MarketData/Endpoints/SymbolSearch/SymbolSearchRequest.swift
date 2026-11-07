//
//  SymbolSearchRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

struct SymbolSearchRequest: APIRequest {
    typealias Response = SymbolSearchResponseDTO

    let query: String

    var path: [String] { MarketEndpoint.symbolSearch.path }

    var method: HTTPMethod { MarketEndpoint.symbolSearch.method }

    var queryItems: [URLQueryItem] {
        [.init(name: MarketQueryKey.query.rawValue, value: query)]
    }
}
