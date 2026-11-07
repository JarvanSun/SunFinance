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
        try await respond(
            Account(
                cash: Money(10_000, .eur),
                buyingPower: Money(10_000, .eur),
                positionsValue: Money(isEmpty ? 0 : 10_622, .eur),
                total: Money(isEmpty ? 10_000 : 20_622, .eur),
                todayGain: Money(isEmpty ? 0 : 84.2, .eur)
            )
        )
    }

    func portfolio() async throws(BrokerageError) -> Portfolio {
        let pool = PreviewObjectPool()
        let open = [
            pool.position("SAP", quantity: 15, value: 3_425, gain: 412.5),
            pool.position("AAPL", quantity: 15, value: 3_197, gain: 466.2),
            pool.position("NVDA", quantity: 15, value: 2_610, gain: -188.4),
            pool.position("ALV", quantity: 4, value: 1_390, gain: 22.8),
        ]
        let closed = [pool.position("KO", quantity: 0, value: 0, gain: 96.3)]
        return try await respond(
            isEmpty ? Portfolio(open: [], closed: []) : Portfolio(open: open, closed: closed)
        )
    }

    func portfolioHistory(range: HistoryRange) async throws(BrokerageError) -> PortfolioHistory {
        let start = Date(timeIntervalSince1970: 1_791_000_000)
        let points = (0..<120).map { index in
            PortfolioValuePoint(
                date: start.addingTimeInterval(Double(index) * 21_600),
                value: Money(
                    Decimal(20_000 + sin(Double(index) / 9) * 400 + Double(index) * 5),
                    .eur
                )
            )
        }
        return try await respond(PortfolioHistory(range: range, points: points))
    }

    private func respond<Value>(_ value: Value) async throws(BrokerageError) -> Value {
        try? await Task.sleep(for: delay)
        if let failure { throw failure }
        return value
    }
}
#endif
