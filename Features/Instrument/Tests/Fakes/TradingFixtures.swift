//
//  TradingFixtures.swift
//  InstrumentTests
//
//  Created by Jiawen Sun on 2026/11/07.
//

import FinanceCore
import Foundation

nonisolated let appleQuote = StockQuote(
    symbol: "AAPL",
    companyName: "Apple Inc.",
    price: Money(200, .usd),
    changePercent: 1,
    marketCap: Money(1, .usd)
)

nonisolated let sampleAccount = Account(
    cash: Money(1_000, .eur),
    buyingPower: Money(1_000, .eur),
    positionsValue: Money(0, .eur),
    total: Money(1_000, .eur),
    todayGain: Money(0, .eur)
)

extension Portfolio {
    nonisolated init(holdingApple quantity: Decimal) {
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
        self.init(open: quantity > 0 ? [position] : [], closed: [])
    }
}

extension OrderPreview {
    nonisolated init(rejection: OrderRejection? = nil, currency: CurrencyCode = .usd) {
        self.init(
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
    nonisolated init(
        _ side: TradeSide = .buy,
        amount: OrderAmount = .shares(2),
        execution: OrderExecution = .market,
        trigger: OrderTrigger = .immediately,
        validity: OrderValidity = .day
    ) {
        self.init(
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
    nonisolated init(_ draft: OrderDraft = .init(), status: OrderStatus) {
        let fill = OrderFill(
            date: testNow,
            quantity: 2,
            price: Money(200, .usd),
            exchangeRate: 1,
            fee: Money(1, .eur),
            total: Money(401, .eur)
        )
        self.init(
            id: "order-1",
            draft: draft,
            quantity: 2,
            currency: .usd,
            status: status,
            createdAt: testNow,
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

nonisolated let sampleFill = Order(status: .filled).fill!

nonisolated let testNow = Date(timeIntervalSince1970: 1_793_718_000)
