//
//  PreviewBrokerage.swift
//  Portfolio
//
//  Created by Jiawen Sun on 2026/11/07.
//

#if DEBUG
import FinanceCore
import Foundation

struct PreviewBrokerage: AccountProviding, PositionProviding, PortfolioHistoryProviding {
    var isEmpty = false
    var failure: BrokerageError?
    var delay = Duration.zero

    func account() async throws(BrokerageError) -> Account {
        try await respond(isEmpty ? Account.dummyWithoutPositions : .dummy)
    }

    func portfolio() async throws(BrokerageError) -> Portfolio {
        try await respond(isEmpty ? Portfolio(open: [], closed: []) : Portfolio.dummy)
    }

    func portfolioHistory(range: HistoryRange) async throws(BrokerageError) -> PortfolioHistory {
        try await respond(PortfolioHistory.dummy(range: range))
    }

    private func respond<Value>(_ value: Value) async throws(BrokerageError) -> Value {
        try? await Task.sleep(for: delay)
        if let failure { throw failure }
        return value
    }
}
#endif
