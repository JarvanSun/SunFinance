//
//  TradingServicesStub.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation
import Synchronization

final class TradingServicesStub: QuoteProviding, AccountProviding, PositionProviding,
    OrderPreviewing, OrderPlacing
{
    struct State {
        var quoteResult: Result<[StockQuote], MarketDataError> = .success([appleQuote])
        var accountResult: Result<Account, BrokerageError> = .success(sampleAccount)
        var portfolioResult: Result<Portfolio, BrokerageError> = .success(.init(holdingApple: 15))
        var previewResult: Result<OrderPreview, BrokerageError> = .success(.init())
        var placeResults: [Result<OrderStatus, BrokerageError>] = [.success(.filled)]
        var previewDelay = Duration.zero
        var placeDelay = Duration.zero
        var previewedDrafts: [OrderDraft] = []
        var placedKeys: [IdempotencyKey] = []
    }

    private let state = Mutex(State())

    var previewedDrafts: [OrderDraft] {
        state.withLock(\.previewedDrafts)
    }

    var placedKeys: [IdempotencyKey] {
        state.withLock(\.placedKeys)
    }

    func update(_ change: (inout State) -> Void) {
        state.withLock { state in change(&state) }
    }

    func quotes(for symbols: [TickerSymbol]) async throws(MarketDataError) -> [StockQuote] {
        try state.withLock(\.quoteResult).get()
    }

    func account() async throws(BrokerageError) -> Account {
        try state.withLock(\.accountResult).get()
    }

    func portfolio() async throws(BrokerageError) -> Portfolio {
        try state.withLock(\.portfolioResult).get()
    }

    func preview(_ draft: OrderDraft) async throws(BrokerageError) -> OrderPreview {
        let delay = state.withLock { state in
            state.previewedDrafts.append(draft)
            return state.previewDelay
        }
        try? await Task.sleep(for: delay)
        return try state.withLock(\.previewResult).get()
    }

    func place(_ draft: OrderDraft, idempotencyKey: IdempotencyKey) async throws(BrokerageError)
        -> Order
    {
        let (result, delay) = state.withLock { state in
            state.placedKeys.append(idempotencyKey)
            let result: Result<OrderStatus, BrokerageError> =
                state.placeResults.isEmpty ? .success(.filled) : state.placeResults.removeFirst()
            return (result, state.placeDelay)
        }
        try? await Task.sleep(for: delay)
        return Order(draft, status: try result.get())
    }
}
