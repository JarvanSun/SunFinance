//
//  OrderOutcomePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation
import SwiftUI

extension OrderOutcome {
    var image: FinanceImage {
        switch self {
        case .filled, .filledWithoutDetails:
            .success
        case .waitingForPrice, .waitingForTrigger, .scheduled, .waitingForOpen:
            .scheduled
        case .cancelled, .expired, .rejected:
            .rejected
        }
    }

    var color: FinanceColor {
        switch self {
        case .filled, .filledWithoutDetails:
            .gain
        case .waitingForPrice, .waitingForTrigger, .scheduled, .waitingForOpen:
            .accent
        case .cancelled, .expired:
            .textSecondary
        case .rejected:
            .critical
        }
    }

    var feedback: SensoryFeedback? {
        switch self {
        case .filled, .filledWithoutDetails:
            .success
        case .waitingForPrice, .waitingForTrigger, .scheduled, .waitingForOpen, .cancelled,
            .expired, .rejected:
            nil
        }
    }

    var doneButtonKind: FinanceButtonKind {
        switch allowsEditing {
        case true:
            .secondary
        case false:
            .primary
        }
    }

    func title(for draft: OrderDraft) -> LocalizedStringResource {
        switch (self, draft.side) {
        case (.filled(let fill), .buy):
            .init(
                "trading.result.filled.buy \(fill.quantity.formattedQuantity()) \(draft.symbol.rawValue)",
                bundle: .module
            )
        case (.filled(let fill), .sell):
            .init(
                "trading.result.filled.sell \(fill.quantity.formattedQuantity()) \(draft.symbol.rawValue)",
                bundle: .module
            )
        case (.filledWithoutDetails, _):
            .init("trading.result.filledWithoutDetails", bundle: .module)
        case (.waitingForPrice, _), (.waitingForTrigger, _), (.scheduled, _), (.waitingForOpen, _):
            .init("trading.result.placed", bundle: .module)
        case (.cancelled, _):
            .init("trading.result.cancelled", bundle: .module)
        case (.expired, _):
            .init("trading.result.expired", bundle: .module)
        case (.rejected, _):
            .init("trading.result.rejected", bundle: .module)
        }
    }

    func detail(for draft: OrderDraft, currency: CurrencyCode) -> LocalizedStringResource {
        switch (self, draft.trigger) {
        case (.filled(let fill), _):
            .init(
                "trading.result.filled.detail \(fill.price.formatted()) \(fill.total.formatted())",
                bundle: .module
            )
        case (.filledWithoutDetails, _):
            .init("trading.result.filledWithoutDetails.detail", bundle: .module)
        case (.waitingForPrice, _):
            .init("trading.result.waitingForPrice", bundle: .module)
        case (.waitingForTrigger, .priceAtOrAbove(let price)),
            (.waitingForTrigger, .priceAtOrBelow(let price)):
            .init(
                "trading.result.waitingForTrigger \(Money(price, currency).formatted())",
                bundle: .module
            )
        case (.scheduled(let date), _):
            .init(
                "trading.result.scheduled \(date.formatted(date: .abbreviated, time: .shortened))",
                bundle: .module
            )
        case (.waitingForOpen, _), (.waitingForTrigger, _):
            .init("trading.result.waitingForOpen", bundle: .module)
        case (.cancelled, _):
            .init("trading.result.cancelled.detail", bundle: .module)
        case (.expired, _):
            .init("trading.result.expired.detail", bundle: .module)
        case (.rejected(let rejection), _):
            rejection.message
        }
    }
}
