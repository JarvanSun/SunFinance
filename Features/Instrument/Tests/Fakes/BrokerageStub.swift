//
//  BrokerageStub.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

struct BrokerageStub: PositionProviding, OrderProviding {
    var portfolio = Portfolio(open: [], closed: [])
    var openOrders: [Order] = []
    var pastOrders: [Order] = []
    var failure: BrokerageError?

    func portfolio() async throws(BrokerageError) -> Portfolio {
        if let failure { throw failure }
        return portfolio
    }

    func orders(
        _ filter: OrderListFilter,
        symbol: TickerSymbol?,
        cursor: String?
    ) async throws(BrokerageError) -> Page<Order> {
        if let failure { throw failure }
        let matching = (filter == .open ? openOrders : pastOrders).filter { order in
            symbol.map { $0 == order.draft.symbol } ?? true
        }
        let start = cursor.flatMap(Int.init) ?? 0
        let end = min(start + pageSize, matching.count)
        return Page(
            elements: Array(matching[start..<end]),
            nextCursor: end < matching.count ? String(end) : nil
        )
    }
}

private extension BrokerageStub {
    var pageSize: Int { 2 }
}

extension Position {
    nonisolated static func holding(_ symbol: TickerSymbol, quantity: Decimal) -> Position {
        let zero = Money(0, .eur)
        return Position(
            symbol: symbol,
            quantity: quantity,
            price: Money(110, .usd),
            averageCost: zero,
            averageLocalCost: Money(0, .usd),
            costBasis: zero,
            marketValue: zero,
            unrealizedGain: zero,
            unrealizedGainPercent: 0,
            realizedGain: zero,
            todayGain: zero,
            currencyEffect: zero,
            totalReturn: zero,
            totalReturnPercent: 0
        )
    }
}

extension Position {
    nonisolated static let euroHolding = Position(
        symbol: "SAP",
        quantity: 2,
        price: Money(200, .eur),
        averageCost: Money(210, .eur),
        averageLocalCost: Money(210, .eur),
        costBasis: Money(420, .eur),
        marketValue: Money(400, .eur),
        unrealizedGain: Money(-20, .eur),
        unrealizedGainPercent: -4.76,
        realizedGain: Money(0, .eur),
        todayGain: Money(2, .eur),
        currencyEffect: Money(0, .eur),
        totalReturn: Money(-20, .eur),
        totalReturnPercent: -4.76
    )
}

extension Order {
    nonisolated static func make(
        _ symbol: TickerSymbol,
        side: TradeSide = .buy,
        execution: OrderExecution = .market,
        trigger: OrderTrigger = .immediately,
        status: OrderStatus,
        fillDate: Date? = nil
    ) -> Order {
        Order(
            id: UUID().uuidString,
            draft: OrderDraft(
                symbol: symbol,
                side: side,
                amount: .shares(1),
                execution: execution,
                trigger: trigger,
                validity: .day
            ),
            quantity: 1,
            currency: .usd,
            status: status,
            createdAt: Date(timeIntervalSince1970: 0),
            fill: fillDate.map {
                OrderFill(
                    date: $0,
                    quantity: 1,
                    price: Money(105, .usd),
                    exchangeRate: 1,
                    fee: Money(1, .eur),
                    total: Money(106, .eur)
                )
            }
        )
    }
}
