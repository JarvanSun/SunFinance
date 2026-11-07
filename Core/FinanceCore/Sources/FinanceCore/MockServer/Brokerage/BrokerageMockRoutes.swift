//
//  BrokerageMockRoutes.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct BrokerageMockRoutes: MockRoute {
    private let brokerage: MockBrokerage

    init(brokerage: MockBrokerage) {
        self.brokerage = brokerage
    }

    func response(to request: MockRequest) throws -> MockResponse? {
        guard let endpoint = BrokerageEndpoint(path: request.path, method: request.method) else {
            return nil
        }
        return try response(for: endpoint, request: request)
    }
}

private extension BrokerageMockRoutes {
    var exchange: MockExchange {
        brokerage.exchange
    }

    func response(for endpoint: BrokerageEndpoint, request: MockRequest) throws -> MockResponse {
        let date = request.date
        switch endpoint {
        case .account:
            return try .init(
                json: brokerage.update(at: date) { $0.account(at: date, exchange: exchange) }
            )
        case .positions:
            return try .init(
                json: brokerage.update(at: date) { $0.positions(at: date, exchange: exchange) }
            )
        case .portfolioHistory:
            guard let range = query(.range, of: request, as: HistoryRange.self) else {
                return .init(status: .badRequest)
            }
            return try .init(
                json: brokerage.update(at: date) {
                    $0.history(range: range, at: date, exchange: exchange)
                }
            )
        case .orders:
            guard let filter = query(.status, of: request, as: OrderListFilter.self) else {
                return .init(status: .badRequest)
            }
            let symbol = query(.symbol, of: request, as: TickerSymbol.self)
            let cursor = request.query(BrokerageQueryKey.cursor.rawValue)
            return try .init(
                json: brokerage.update(at: date) {
                    $0.ordersPage(
                        OrdersQuery(filter: filter, symbol: symbol, cursor: cursor),
                        at: date,
                        exchange: exchange
                    )
                }
            )
        case .previewOrder:
            guard let draft = draft(in: request) else { return .init(status: .badRequest) }

            return try .init(
                json: brokerage.update(at: date) { $0.preview(draft, at: date, exchange: exchange) }
            )
        case .placeOrder:
            guard let draft = draft(in: request) else { return .init(status: .badRequest) }

            let key = request.header(.idempotencyKey)
            return try .init(
                json: brokerage.update(at: date) { ledger in
                    let order = ledger.place(draft, key: key, at: date, exchange: exchange)
                    return ledger.dto(of: order, at: date, exchange: exchange)
                },
                status: .created
            )
        case .cancelOrder(let id):
            let order = brokerage.update(at: date) { ledger in
                ledger.cancel(orderID: id).map { ledger.dto(of: $0, at: date, exchange: exchange) }
            }
            return try order.map { try .init(json: $0) } ?? .init(status: .notFound)
        }
    }

    func query<Value: RawRepresentable>(
        _ key: BrokerageQueryKey,
        of request: MockRequest,
        as type: Value.Type
    ) -> Value? where Value.RawValue == String {
        request.query(key.rawValue).flatMap(Value.init(rawValue:))
    }

    func draft(in request: MockRequest) -> OrderDraft? {
        guard
            let body = request.body,
            let dto = try? makeBackendDecoder().decode(OrderDraftDTO.self, from: body)
        else { return nil }

        return try? OrderDraft(dto)
    }
}
