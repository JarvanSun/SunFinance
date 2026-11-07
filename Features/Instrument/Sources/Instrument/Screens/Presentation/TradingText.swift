//
//  TradingText.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

enum TradingText {
    static var sellAll: LocalizedStringResource {
        .init("trading.amount.sellAll", bundle: .module)
    }

    static var executionTitle: LocalizedStringResource {
        .init("trading.execution.title", bundle: .module)
    }

    static var triggerTitle: LocalizedStringResource {
        .init("trading.trigger.title", bundle: .module)
    }

    static var triggerTimeField: LocalizedStringResource {
        .init("trading.trigger.time.field", bundle: .module)
    }

    static var validityTitle: LocalizedStringResource {
        .init("trading.validity.title", bundle: .module)
    }

    static var marketClosed: LocalizedStringResource {
        .init("trading.header.marketClosed", bundle: .module)
    }

    static var reviewButton: LocalizedStringResource {
        .init("trading.review.button", bundle: .module)
    }

    static var cancel: LocalizedStringResource {
        .init("trading.cancel", bundle: .module)
    }

    static var loading: LocalizedStringResource {
        .init("trading.loading", bundle: .module)
    }

    static var retry: LocalizedStringResource {
        .init("trading.failure.retry", bundle: .module)
    }

    static var reviewTitle: LocalizedStringResource {
        .init("trading.review.title", bundle: .module)
    }

    static var reviewNote: LocalizedStringResource {
        .init("trading.review.note", bundle: .module)
    }

    static var editOrder: LocalizedStringResource {
        .init("trading.review.edit", bundle: .module)
    }

    static var done: LocalizedStringResource {
        .init("trading.result.done", bundle: .module)
    }

    static var typeRow: LocalizedStringResource {
        .init("trading.review.row.type", bundle: .module)
    }

    static var triggerRow: LocalizedStringResource {
        .init("trading.review.row.trigger", bundle: .module)
    }

    static var validityRow: LocalizedStringResource {
        .init("trading.review.row.validity", bundle: .module)
    }

    static var quantityRow: LocalizedStringResource {
        .init("trading.review.row.quantity", bundle: .module)
    }

    static var priceRow: LocalizedStringResource {
        .init("trading.review.row.price", bundle: .module)
    }

    static var rateRow: LocalizedStringResource {
        .init("trading.review.row.rate", bundle: .module)
    }

    static var feeRow: LocalizedStringResource {
        .init("trading.review.row.fee", bundle: .module)
    }

    static var cashAfterRow: LocalizedStringResource {
        .init("trading.review.row.cashAfter", bundle: .module)
    }

    static func buyingPower(_ amount: String) -> LocalizedStringResource {
        .init("trading.header.buyingPower \(amount)", bundle: .module)
    }

    static func heldShares(_ quantity: String, count: Double) -> LocalizedStringResource {
        .init("trading.header.held \(quantity) \(count)", bundle: .module)
    }

    static func rate(currency: String, inEuros: String) -> LocalizedStringResource {
        .init("trading.review.row.rate.value \(currency) \(inEuros)", bundle: .module)
    }
}
