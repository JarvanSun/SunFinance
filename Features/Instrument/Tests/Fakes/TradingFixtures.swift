//
//  TradingFixtures.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

extension StockQuote {
    nonisolated static var apple: StockQuote {
        StockQuote(
            symbol: "AAPL",
            companyName: "Apple Inc.",
            price: Money(200, .usd),
            changePercent: 1,
            marketCap: Money(1, .usd)
        )
    }
}

extension Account {
    nonisolated static var sample: Account {
        Account(
            cash: Money(1_000, .eur),
            buyingPower: Money(1_000, .eur),
            positionsValue: Money(0, .eur),
            total: Money(1_000, .eur),
            todayGain: Money(0, .eur)
        )
    }
}

extension Portfolio {
    nonisolated static func holdingApple(_ quantity: Decimal) -> Portfolio {
        let zero = Money(0, .eur)
        let position = Position(
            symbol: "AAPL",
            quantity: quantity,
            price: Money(200, .usd),
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
        return Portfolio(open: quantity > 0 ? [position] : [], closed: [])
    }
}

extension OrderPreview {
    nonisolated static func sample(rejection: OrderRejection? = nil, currency: CurrencyCode = .usd)
        -> OrderPreview
    {
        OrderPreview(
            quantity: 2,
            price: Money(200, currency),
            exchangeRate: currency == .eur ? 1 : Decimal(string: "0.92")!,
            fee: Money(1, .eur),
            total: Money(369, .eur),
            cashAfter: Money(631, .eur),
            rejection: rejection
        )
    }
}

extension OrderDraft {
    nonisolated static func make(
        _ side: TradeSide = .buy,
        amount: OrderAmount = .shares(2),
        execution: OrderExecution = .market,
        trigger: OrderTrigger = .immediately,
        validity: OrderValidity = .day
    ) -> OrderDraft {
        OrderDraft(
            symbol: "AAPL",
            side: side,
            amount: amount,
            execution: execution,
            trigger: trigger,
            validity: validity
        )
    }
}

extension Order {
    nonisolated static func make(_ draft: OrderDraft = .make(), status: OrderStatus) -> Order {
        let fill = OrderFill(
            date: .testNow,
            quantity: 2,
            price: Money(200, .usd),
            exchangeRate: 1,
            fee: Money(1, .eur),
            total: Money(401, .eur)
        )
        return Order(
            id: "order-1",
            draft: draft,
            quantity: 2,
            currency: .usd,
            status: status,
            createdAt: .testNow,
            fill: status == .filled ? fill : nil
        )
    }
}

extension Order {
    nonisolated var withoutFill: Order {
        Order(
            id: id,
            draft: draft,
            quantity: quantity,
            currency: currency,
            status: status,
            createdAt: createdAt,
            fill: nil
        )
    }
}

extension OrderFill {
    nonisolated static var filledSample: OrderFill {
        Order.make(status: .filled).fill!
    }
}

extension Date {
    nonisolated static let testNow = Date(timeIntervalSince1970: 1_793_718_000)
}
