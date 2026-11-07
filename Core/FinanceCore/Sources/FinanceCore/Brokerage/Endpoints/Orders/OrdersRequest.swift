//
//  OrdersRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

struct OrdersRequest: APIRequest {
    typealias Response = OrdersResponseDTO

    let filter: OrderListFilter
    let symbol: TickerSymbol?
    let cursor: String?

    var path: [String] { BrokerageEndpoint.orders.path }

    var method: HTTPMethod { BrokerageEndpoint.orders.method }

    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: BrokerageQueryKey.status.rawValue, value: filter.rawValue),
            symbol.map {
                URLQueryItem(name: BrokerageQueryKey.symbol.rawValue, value: $0.rawValue)
            },
            cursor.map { URLQueryItem(name: BrokerageQueryKey.cursor.rawValue, value: $0) },
        ]
        .compactMap(\.self)
    }
}
