//
//  OrderDraftPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension OrderDraft {
    var headline: LocalizedStringResource {
        switch (amount, side) {
        case (.shares(let quantity), .buy):
            .init(
                "trading.review.summary.buy \(quantity.formattedQuantity()) \(symbol.rawValue)",
                bundle: .module
            )
        case (.shares(let quantity), .sell):
            .init(
                "trading.review.summary.sell \(quantity.formattedQuantity()) \(symbol.rawValue)",
                bundle: .module
            )
        case (.euros(let euros), .buy):
            .init(
                "trading.review.summary.euros.buy \(Money(euros, .eur).formatted()) \(symbol.rawValue)",
                bundle: .module
            )
        case (.euros(let euros), .sell):
            .init(
                "trading.review.summary.euros.sell \(Money(euros, .eur).formatted()) \(symbol.rawValue)",
                bundle: .module
            )
        }
    }

    func termRows(currency: CurrencyCode) -> [LabeledRow] {
        [
            LabeledRow(
                id: "type",
                title: TradingText.typeRow,
                value: .localized(executionText(currency: currency))
            ),
            LabeledRow(
                id: "trigger",
                title: TradingText.triggerRow,
                value: .localized(triggerText(currency: currency))
            ),
            LabeledRow(
                id: "validity",
                title: TradingText.validityRow,
                value: .localized(validity.segmentTitle)
            ),
        ]
    }
}

private extension OrderDraft {
    func executionText(currency: CurrencyCode) -> LocalizedStringResource {
        switch execution {
        case .market:
            .init("trading.review.execution.market", bundle: .module)
        case .limit(let price):
            .init(
                "trading.review.execution.limit \(Money(price, currency).formatted())",
                bundle: .module
            )
        }
    }

    func triggerText(currency: CurrencyCode) -> LocalizedStringResource {
        switch trigger {
        case .immediately:
            .init("trading.review.trigger.now", bundle: .module)
        case .priceAtOrAbove(let price), .priceAtOrBelow(let price):
            .init(
                "trading.review.trigger.price \(Money(price, currency).formatted())",
                bundle: .module
            )
        case .at(let date):
            .init(
                "trading.review.trigger.time \(date.formatted(date: .abbreviated, time: .shortened))",
                bundle: .module
            )
        }
    }
}
