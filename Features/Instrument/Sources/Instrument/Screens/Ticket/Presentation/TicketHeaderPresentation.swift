//
//  TicketHeaderPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension TicketContext {
    var priceText: String {
        quote.price.formatted()
    }

    var priceValue: Double {
        quote.price.doubleValue
    }

    func holdingsText(for side: TradeSide) -> LocalizedStringResource {
        switch side {
        case .buy:
            TradingText.buyingPower(buyingPower.formatted())
        case .sell:
            TradingText.heldShares(
                heldShares.formattedQuantity(),
                count: NSDecimalNumber(decimal: heldShares).doubleValue
            )
        }
    }

    var marketNotice: LocalizedStringResource? {
        switch quote.isMarketOpen {
        case true:
            nil
        case false:
            TradingText.marketClosed
        }
    }
}
