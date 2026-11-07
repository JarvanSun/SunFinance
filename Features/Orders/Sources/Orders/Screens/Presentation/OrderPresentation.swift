//
//  OrderPresentation.swift
//  Orders
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension Order {
    var headline: LocalizedStringResource {
        let symbol = draft.symbol.rawValue
        return switch (draft.amount, draft.side) {
        case (.shares, .buy):
            .init("orders.headline.buy \(quantity.formattedQuantity()) \(symbol)", bundle: .module)
        case (.shares, .sell):
            .init("orders.headline.sell \(quantity.formattedQuantity()) \(symbol)", bundle: .module)
        case (.euros(let euros), .buy):
            .init(
                "orders.headline.euros.buy \(Money(euros, .eur).formatted()) \(symbol)",
                bundle: .module
            )
        case (.euros(let euros), .sell):
            .init(
                "orders.headline.euros.sell \(Money(euros, .eur).formatted()) \(symbol)",
                bundle: .module
            )
        }
    }

    var executionText: LocalizedStringResource {
        switch draft.execution {
        case .market:
            .init("orders.execution.market", bundle: .module)
        case .limit(let price):
            .init("orders.execution.limit \(Money(price, currency).formatted())", bundle: .module)
        }
    }

    var triggerText: LocalizedStringResource {
        switch draft.trigger {
        case .immediately:
            .init("orders.trigger.now", bundle: .module)
        case .priceAtOrAbove(let price), .priceAtOrBelow(let price):
            .init("orders.trigger.price \(Money(price, currency).formatted())", bundle: .module)
        case .at(let date):
            .init("orders.trigger.time \(date.formatted(.orderMoment))", bundle: .module)
        }
    }

    var validityText: LocalizedStringResource {
        switch draft.validity {
        case .day:
            .init("orders.validity.day", bundle: .module)
        case .goodTillCancelled:
            .init("orders.validity.gtc", bundle: .module)
        }
    }

    var rowSubtitle: LocalizedStringResource {
        let shares = quantity.formattedQuantity()
        let count = NSDecimalNumber(decimal: quantity).doubleValue
        return switch (draft.amount, draft.side) {
        case (.shares, .buy):
            .init("orders.row.shares.buy \(shares) \(count)", bundle: .module)
        case (.shares, .sell):
            .init("orders.row.shares.sell \(shares) \(count)", bundle: .module)
        case (.euros(let euros), .buy):
            .init("orders.row.euros.buy \(Money(euros, .eur).formatted())", bundle: .module)
        case (.euros(let euros), .sell):
            .init("orders.row.euros.sell \(Money(euros, .eur).formatted())", bundle: .module)
        }
    }

    var rowKind: LocalizedStringResource {
        switch draft.trigger {
        case .priceAtOrAbove(let price), .priceAtOrBelow(let price):
            .init("orders.row.stop \(Money(price, currency).formatted())", bundle: .module)
        case .at(let date):
            .init("orders.row.scheduled \(date.formatted(.orderMoment))", bundle: .module)
        case .immediately:
            executionText
        }
    }

    var settledTotal: String? {
        fill.map { fill in
            Money(draft.side.cashSign * fill.total.amount, fill.total.currency).formattedSigned()
        }
    }

    var accessibilityLabel: LocalizedStringResource {
        let symbol = draft.symbol.rawValue
        return .init(
            "orders.row.accessibilityLabel \(symbol) \(rowSubtitle) \(rowKind) \(status.title)",
            bundle: .module
        )
    }
}

private extension TradeSide {
    var cashSign: Decimal {
        switch self {
        case .buy:
            -1
        case .sell:
            1
        }
    }
}
