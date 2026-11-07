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
        let amount = buyingPower.formatted()
        let quantity = heldShares.formattedQuantity()
        let count = NSDecimalNumber(decimal: heldShares).doubleValue
        return switch side {
        case .buy:
            .init("trading.header.buyingPower \(amount)", bundle: .module)
        case .sell:
            .init("trading.header.held \(quantity) \(count)", bundle: .module)
        }
    }

    var marketNotice: LocalizedStringResource? {
        switch quote.isMarketOpen {
        case true:
            nil
        case false:
            .init("trading.header.marketClosed", bundle: .module)
        }
    }
}
