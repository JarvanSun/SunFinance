//
//  BrokerageService.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation
import SunCore

public struct BrokerageService:
    AccountProviding, PositionProviding, PortfolioHistoryProviding,
    OrderPreviewing, OrderPlacing, OrderProviding, OrderCancelling
{
    private let client: BackendClient

    public init(environment: ServerEnvironment) {
        self.init(client: BackendClient(environment: environment))
    }

    init(client: BackendClient) {
        self.client = client
    }

    public func place(_ draft: OrderDraft, idempotencyKey: IdempotencyKey)
        async throws(BrokerageError) -> Order
    {
        try Order(try await send(PlaceOrderRequest(draft: draft, idempotencyKey: idempotencyKey)))
    }

    public func cancel(orderID: Order.ID) async throws(BrokerageError) -> Order {
        try Order(try await send(CancelOrderRequest(orderID: orderID)))
    }

    public func account() async throws(BrokerageError) -> Account {
        try Account(try await send(AccountRequest()))
    }

    public func portfolio() async throws(BrokerageError) -> Portfolio {
        try Portfolio(try await send(PositionsRequest()))
    }

    public func portfolioHistory(range: HistoryRange) async throws(BrokerageError)
        -> PortfolioHistory
    {
        try PortfolioHistory(try await send(PortfolioHistoryRequest(range: range)))
    }

    public func preview(_ draft: OrderDraft) async throws(BrokerageError) -> OrderPreview {
        try OrderPreview(try await send(PreviewOrderRequest(draft: draft)))
    }

    public func orders(
        _ filter: OrderListFilter,
        symbol: TickerSymbol?,
        cursor: String?
    ) async throws(BrokerageError) -> Page<Order> {
        let response = try await send(OrdersRequest(filter: filter, symbol: symbol, cursor: cursor))
        return .init(
            elements: try response.orders.map(Order.init(_:)),
            nextCursor: response.nextCursor
        )
    }
}

private extension BrokerageService {
    func send<Request: APIRequest>(_ request: Request) async throws(BrokerageError)
        -> Request.Response
    {
        do {
            return try await client.send(request)
        } catch {
            throw BrokerageError(error)
        }
    }
}
