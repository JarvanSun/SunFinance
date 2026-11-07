//
//  PreviewOrderRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore

struct PreviewOrderRequest: APIRequest {
    typealias Response = PreviewOrderResponseDTO

    let draft: OrderDraft

    var path: [String] { BrokerageEndpoint.previewOrder.path }

    var method: HTTPMethod { BrokerageEndpoint.previewOrder.method }

    var body: RequestBody? {
        .json(draft.dto)
    }
}
