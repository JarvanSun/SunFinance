//
//  MockLedger.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct MockLedger: Codable, Sendable {
    var cash: Decimal
    var orders: [LedgerOrder]
    var fills: [LedgerFill]
    var cashEntries: [CashEntry]
    var idempotencyKeys: [String: Order.ID]
    var settledUntil: Date

    var book: PositionBook {
        PositionBook(fills: fills)
    }
}

extension MockLedger {
    static var fee: Decimal { 1 }

    static func seeded(at date: Date, exchange: MockExchange) -> MockLedger {
        let fills =
            seedTrades
            .compactMap { trade in
                let day = date.addingTimeInterval(-trade.daysAgo * secondsPerDay)
                return trade.fill(closingBefore: day, exchange: exchange)
            }
            .sorted { $0.date < $1.date }
        let spent = fills.reduce(Decimal.zero) { $0 - $1.cashEffect }
        var ledger = MockLedger(
            cash: 0,
            orders: [],
            fills: [],
            cashEntries: [],
            idempotencyKeys: [:],
            settledUntil: date
        )
        ledger.book(
            deposit: startingCash + spent,
            at: date.addingTimeInterval(-depositDaysAgo * secondsPerDay)
        )
        for fill in fills {
            ledger.book(fill)
        }
        return ledger
    }

    mutating func book(deposit amount: Decimal, at date: Date) {
        cash += amount
        cashEntries.append(CashEntry(date: date, amount: amount))
    }

    mutating func book(_ fill: LedgerFill) {
        fills.append(fill)
        cash += fill.cashEffect
        cashEntries.append(CashEntry(date: fill.date, amount: fill.cashEffect))
    }
}

private extension MockLedger {
    static var startingCash: Decimal { 10_000 }
    static var depositDaysAgo: Double { 200 }
    static var secondsPerDay: TimeInterval { 86_400 }

    static var seedTrades: [SeedTrade] {
        [
            SeedTrade(symbol: "AAPL", side: .buy, quantity: 10, daysAgo: 170),
            SeedTrade(symbol: "SAP", side: .buy, quantity: 20, daysAgo: 150),
            SeedTrade(symbol: "KO", side: .buy, quantity: 30, daysAgo: 140),
            SeedTrade(symbol: "NVDA", side: .buy, quantity: 15, daysAgo: 120),
            SeedTrade(symbol: "AAPL", side: .buy, quantity: 5, daysAgo: 60),
            SeedTrade(symbol: "SAP", side: .sell, quantity: 5, daysAgo: 40),
            SeedTrade(symbol: "KO", side: .sell, quantity: 30, daysAgo: 30),
            SeedTrade(symbol: "ALV", side: .buy, quantity: 4, daysAgo: 20),
        ]
    }
}

private struct SeedTrade {
    let symbol: TickerSymbol
    let side: TradeSide
    let quantity: Decimal
    let daysAgo: Double

    func fill(closingBefore day: Date, exchange: MockExchange) -> LedgerFill? {
        guard
            let close = exchange.venue(of: symbol)?.closes(atOrBefore: day).first,
            let price = exchange.price(of: symbol, at: close)
        else { return nil }

        return LedgerFill(
            id: UUID().uuidString,
            orderID: UUID().uuidString,
            symbol: symbol,
            side: side,
            quantity: quantity,
            price: price.amount,
            currency: price.currency,
            exchangeRate: exchange.eurRate(of: price.currency, at: close),
            fee: MockLedger.fee,
            date: close
        )
    }
}
