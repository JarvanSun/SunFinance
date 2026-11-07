//
//  PositionsRequest.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore

struct PositionsRequest: APIRequest {
    typealias Response = PositionsResponseDTO

    var path: [String] { BrokerageEndpoint.positions.path }

    var method: HTTPMethod { BrokerageEndpoint.positions.method }
}
