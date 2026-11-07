//
//  PreviewServices.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

struct PreviewServices: QuoteProviding, AccountProviding, PositionProviding, OrderPreviewing,
    OrderPlacing
{
    var rejection: OrderRejection?
    var failure: BrokerageError?
    var delay = Duration.zero
    var isMarketOpen = true

    func quotes(for symbols: [TickerSymbol]) async throws(MarketDataError) -> [StockQuote] {
        try? await Task.sleep(for: delay)
        return [StockQuote.dummy(isMarketOpen: isMarketOpen)]
    }

    func account() async throws(BrokerageError) -> Account {
        try await respond(Account.dummy)
    }

    func portfolio() async throws(BrokerageError) -> Portfolio {
        try await respond(Portfolio.dummy)
    }

    func preview(_ draft: OrderDraft) async throws(BrokerageError) -> OrderPreview {
        try await respond(OrderPreview.dummy(rejection: rejection))
    }

    func place(_ draft: OrderDraft, idempotencyKey: IdempotencyKey) async throws(BrokerageError)
        -> Order
    {
        try await respond(Order.dummy(draft, status: .filled))
    }

    private func respond<Value>(_ value: Value) async throws(BrokerageError) -> Value {
        try? await Task.sleep(for: delay)
        if let failure { throw failure }
        return value
    }
}
#endif
