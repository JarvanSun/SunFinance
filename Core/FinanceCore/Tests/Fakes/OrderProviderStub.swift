//
//  OrderProviderStub.swift
//  FinanceCoreTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Synchronization

@testable import FinanceCore

final class OrderProviderStub: OrderProviding {
    struct Request: Equatable {
        let filter: OrderListFilter
        let symbol: TickerSymbol?
        let cursor: String?
    }

    private let pages: [String?: Result<Page<Order>, BrokerageError>]
    private let recorded = Mutex<[Request]>([])

    var requests: [Request] {
        recorded.withLock(\.self)
    }

    init(pages: [String?: Result<Page<Order>, BrokerageError>]) {
        self.pages = pages
    }

    func orders(
        _ filter: OrderListFilter,
        symbol: TickerSymbol?,
        cursor: String?
    ) async throws(BrokerageError) -> Page<Order> {
        recorded.withLock { $0.append(Request(filter: filter, symbol: symbol, cursor: cursor)) }
        return try (pages[cursor] ?? .success(.init(elements: [], nextCursor: nil))).get()
    }
}
