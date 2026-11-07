//
//  OrderDraft.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

public struct OrderDraft: Hashable, Sendable {
    public let symbol: TickerSymbol
    public let side: TradeSide
    public let amount: OrderAmount
    public let execution: OrderExecution
    public let trigger: OrderTrigger
    public let validity: OrderValidity

    public init(
        symbol: TickerSymbol,
        side: TradeSide,
        amount: OrderAmount,
        execution: OrderExecution,
        trigger: OrderTrigger,
        validity: OrderValidity
    ) {
        self.symbol = symbol
        self.side = side
        self.amount = amount
        self.execution = execution
        self.trigger = trigger
        self.validity = validity
    }
}

// MARK: - DTO

extension OrderDraft {
    var dto: OrderDraftDTO {
        OrderDraftDTO(
            symbol: symbol.rawValue,
            side: side.rawValue,
            shares: amount.shares,
            cashAmount: amount.euros,
            execution: execution.code,
            limitPrice: execution.limitPrice,
            trigger: trigger.code,
            triggerPrice: trigger.price,
            triggerTime: trigger.time,
            validity: validity.rawValue
        )
    }

    init(_ dto: OrderDraftDTO) throws(BrokerageError) {
        guard
            let side = TradeSide(rawValue: dto.side),
            let amount = OrderAmount(shares: dto.shares, euros: dto.cashAmount),
            let execution = OrderExecution(code: dto.execution, limitPrice: dto.limitPrice),
            let trigger = OrderTrigger(
                code: dto.trigger,
                price: dto.triggerPrice,
                time: dto.triggerTime
            ),
            let validity = OrderValidity(rawValue: dto.validity)
        else { throw .decoding }

        self.init(
            symbol: TickerSymbol(rawValue: dto.symbol),
            side: side,
            amount: amount,
            execution: execution,
            trigger: trigger,
            validity: validity
        )
    }
}

// MARK: - OrderAmount

private extension OrderAmount {
    init?(shares: Decimal?, euros: Decimal?) {
        switch (shares, euros) {
        case (.some(let shares), nil):
            self = .shares(shares)
        case (nil, .some(let euros)):
            self = .euros(euros)
        default:
            return nil
        }
    }

    var shares: Decimal? {
        switch self {
        case .shares(let shares):
            shares
        case .euros:
            nil
        }
    }

    var euros: Decimal? {
        switch self {
        case .shares:
            nil
        case .euros(let euros):
            euros
        }
    }
}

// MARK: - OrderExecution

private extension OrderExecution {
    init?(code: String, limitPrice: Decimal?) {
        switch (code, limitPrice) {
        case ("market", _):
            self = .market
        case ("limit", .some(let price)):
            self = .limit(price)
        default:
            return nil
        }
    }

    var code: String {
        switch self {
        case .market:
            "market"
        case .limit:
            "limit"
        }
    }

    var limitPrice: Decimal? {
        switch self {
        case .market:
            nil
        case .limit(let price):
            price
        }
    }
}

// MARK: - OrderTrigger

private extension OrderTrigger {
    init?(code: String, price: Decimal?, time: Date?) {
        switch (code, price, time) {
        case ("now", _, _):
            self = .immediately
        case ("price_at_or_above", .some(let price), _):
            self = .priceAtOrAbove(price)
        case ("price_at_or_below", .some(let price), _):
            self = .priceAtOrBelow(price)
        case ("time", _, .some(let time)):
            self = .at(time)
        default:
            return nil
        }
    }

    var code: String {
        switch self {
        case .immediately:
            "now"
        case .priceAtOrAbove:
            "price_at_or_above"
        case .priceAtOrBelow:
            "price_at_or_below"
        case .at:
            "time"
        }
    }

    var price: Decimal? {
        switch self {
        case .priceAtOrAbove(let price), .priceAtOrBelow(let price):
            price
        case .immediately, .at:
            nil
        }
    }

    var time: Date? {
        switch self {
        case .at(let time):
            time
        case .immediately, .priceAtOrAbove, .priceAtOrBelow:
            nil
        }
    }
}
