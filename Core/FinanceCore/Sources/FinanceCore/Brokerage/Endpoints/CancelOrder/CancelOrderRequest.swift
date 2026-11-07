//
//  CancelOrderRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore

struct CancelOrderRequest: APIRequest {
    typealias Response = OrderDTO

    let orderID: Order.ID

    var path: [String] { BrokerageEndpoint.cancelOrder(orderID).path }

    var method: HTTPMethod { BrokerageEndpoint.cancelOrder(orderID).method }
}
