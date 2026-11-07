//
//  PlaceOrderRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore

struct PlaceOrderRequest: APIRequest {
    typealias Response = OrderDTO

    let draft: OrderDraft
    let idempotencyKey: IdempotencyKey

    var path: [String] { BrokerageEndpoint.placeOrder.path }

    var method: HTTPMethod { BrokerageEndpoint.placeOrder.method }

    var headers: [String: String] {
        [HeaderKey.idempotencyKey.rawValue: idempotencyKey.rawValue]
    }

    var body: RequestBody? {
        .json(draft.dto)
    }
}
