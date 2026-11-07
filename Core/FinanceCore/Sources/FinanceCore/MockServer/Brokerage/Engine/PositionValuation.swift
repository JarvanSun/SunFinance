//
//  PositionValuation.swift
//  FinanceCore
//
//  Created by Jiawen Sun on 2026/11/07.
//

import Foundation

struct PositionValuation: Equatable, Sendable {
    let holding: Holding
    let price: Decimal
    let rate: Decimal
    let previousClose: Decimal
    let previousRate: Decimal
    let quantityAtPreviousClose: Decimal
    let fillsToday: [LedgerFill]

    var marketValue: Decimal {
        holding.quantity * price * rate
    }

    var unrealizedGain: Decimal {
        marketValue - holding.costBasis
    }

    var unrealizedGainPercent: Decimal {
        holding.costBasis > 0 ? unrealizedGain / holding.costBasis * percentScale : 0
    }

    var todayGain: Decimal {
        let now = price * rate
        let held = quantityAtPreviousClose * (now - previousClose * previousRate)
        let traded = fillsToday.reduce(Decimal.zero) { sum, fill in
            switch fill.side {
            case .buy:
                sum + fill.quantity * (now - fill.priceInEuros)
            case .sell:
                sum + fill.quantity * (fill.priceInEuros - now)
            }
        }
        return held + traded
    }

    var currencyEffect: Decimal {
        holding.quantity * price * (rate - holding.averageRate)
    }

    var totalReturn: Decimal {
        holding.realizedGain + unrealizedGain
    }

    var totalReturnPercent: Decimal {
        holding.invested > 0 ? totalReturn / holding.invested * percentScale : 0
    }
}

private extension PositionValuation {
    var percentScale: Decimal { 100 }
}
