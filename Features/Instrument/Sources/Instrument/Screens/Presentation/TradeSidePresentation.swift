//
//  TradeSidePresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension TradeSide {
    var segmentTitle: LocalizedStringResource {
        switch self {
        case .buy: .init("trading.side.buy", bundle: .module)
        case .sell: .init("trading.side.sell", bundle: .module)
        }
    }

    func ticketTitle(for symbol: TickerSymbol) -> LocalizedStringResource {
        switch self {
        case .buy: .init("trading.ticket.title.buy \(symbol.rawValue)", bundle: .module)
        case .sell: .init("trading.ticket.title.sell \(symbol.rawValue)", bundle: .module)
        }
    }

    var limitFieldTitle: LocalizedStringResource {
        switch self {
        case .buy: .init("trading.limit.field.buy", bundle: .module)
        case .sell: .init("trading.limit.field.sell", bundle: .module)
        }
    }

    var triggerPriceFieldTitle: LocalizedStringResource {
        switch self {
        case .buy: .init("trading.trigger.price.field.buy", bundle: .module)
        case .sell: .init("trading.trigger.price.field.sell", bundle: .module)
        }
    }

    var estimateTitle: LocalizedStringResource {
        switch self {
        case .buy: .init("trading.estimate.total.buy", bundle: .module)
        case .sell: .init("trading.estimate.total.sell", bundle: .module)
        }
    }

    var totalRowTitle: LocalizedStringResource {
        switch self {
        case .buy: .init("trading.review.row.total.buy", bundle: .module)
        case .sell: .init("trading.review.row.total.sell", bundle: .module)
        }
    }

    var slideTitle: LocalizedStringResource {
        switch self {
        case .buy: .init("trading.review.slide.buy", bundle: .module)
        case .sell: .init("trading.review.slide.sell", bundle: .module)
        }
    }

    var actionTitle: LocalizedStringResource {
        switch self {
        case .buy: .init("quoteDetail.trade.buy", bundle: .module)
        case .sell: .init("quoteDetail.trade.sell", bundle: .module)
        }
    }

    var accessibilityIdentifier: InstrumentAccessibility {
        switch self {
        case .buy: .buyButton
        case .sell: .sellButton
        }
    }

    var fill: FinanceColor {
        switch self {
        case .buy: .accent
        case .sell: .loss
        }
    }
}
