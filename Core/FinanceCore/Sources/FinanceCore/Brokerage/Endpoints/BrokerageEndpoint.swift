//
//  BrokerageEndpoint.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import SunCore

enum BrokerageEndpoint: Equatable, Sendable {
    case account
    case positions
    case portfolioHistory
    case orders
    case previewOrder
    case placeOrder
    case cancelOrder(Order.ID)

    var path: [String] {
        switch self {
        case .account:
            [version, BrokeragePathSegment.account.rawValue]
        case .positions:
            [
                version, BrokeragePathSegment.portfolio.rawValue,
                BrokeragePathSegment.positions.rawValue,
            ]
        case .portfolioHistory:
            [
                version, BrokeragePathSegment.portfolio.rawValue,
                BrokeragePathSegment.history.rawValue,
            ]
        case .orders, .placeOrder:
            [version, BrokeragePathSegment.orders.rawValue]
        case .previewOrder:
            [version, BrokeragePathSegment.orders.rawValue, BrokeragePathSegment.preview.rawValue]
        case .cancelOrder(let id):
            [version, BrokeragePathSegment.orders.rawValue, id]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .account, .positions, .portfolioHistory, .orders:
            .get
        case .previewOrder, .placeOrder:
            .post
        case .cancelOrder:
            .delete
        }
    }

    init?(path: [String], method: HTTPMethod) {
        let endpoint = brokerageEndpoint(matching: path, method: method)
        guard let endpoint, endpoint.path == path, endpoint.method == method else { return nil }

        self = endpoint
    }
}

private extension BrokerageEndpoint {
    var version: String { APIVersion.v1.rawValue }
}

private func brokerageEndpoint(matching path: [String], method: HTTPMethod) -> BrokerageEndpoint? {
    let fixedEndpoints: [BrokerageEndpoint] = [
        .account,
        .positions,
        .portfolioHistory,
        .orders,
        .previewOrder,
        .placeOrder,
    ]
    let fixed = fixedEndpoints.first { $0.path == path && $0.method == method }
    switch (fixed, path.last) {
    case (.some(let endpoint), _):
        return endpoint
    case (nil, .some(let id)):
        return .cancelOrder(id)
    case (nil, nil):
        return nil
    }
}
