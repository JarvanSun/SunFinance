//
//  PortfolioHistoryRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

struct PortfolioHistoryRequest: APIRequest {
    typealias Response = PortfolioHistoryResponseDTO

    let range: HistoryRange

    var path: [String] { BrokerageEndpoint.portfolioHistory.path }

    var method: HTTPMethod { BrokerageEndpoint.portfolioHistory.method }

    var queryItems: [URLQueryItem] {
        [.init(name: BrokerageQueryKey.range.rawValue, value: range.rawValue)]
    }
}
