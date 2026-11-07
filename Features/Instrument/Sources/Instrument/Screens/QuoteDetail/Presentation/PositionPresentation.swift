//
//  PositionPresentation.swift
//  Instrument
//
//  Created by Jiawen Sun on 2026/11/07.
//

import DesignSystem
import FinanceCore
import Foundation

extension Position {
    var metrics: [Metric] {
        [
            Metric(
                id: MetricID.value.rawValue,
                label: QuoteDetailText.positionBuyIn(costBasis.formatted()),
                value: marketValue.formatted()
            ),
            Metric(
                id: MetricID.gain.rawValue,
                label: QuoteDetailText.positionSinceBuy,
                value: unrealizedGain.formattedSigned(),
                trend: GainTrend(unrealizedGain.amount)
            ),
            Metric(
                id: MetricID.price.rawValue,
                label: QuoteDetailText.positionAverageBuyIn(averageCostInPriceCurrency.formatted()),
                value: price.formatted()
            ),
            Metric(
                id: MetricID.gainPercent.rawValue,
                label: QuoteDetailText.positionSinceBuyPercent,
                value: unrealizedGainPercent.formatted(.signedPercent),
                trend: GainTrend(unrealizedGain.amount)
            ),
            Metric(
                id: MetricID.shares.rawValue,
                label: QuoteDetailText.positionShares,
                value: quantity.formattedQuantity()
            ),
            Metric(
                id: MetricID.today.rawValue,
                label: QuoteDetailText.positionToday,
                value: todayGain.formattedSigned(),
                trend: GainTrend(todayGain.amount)
            ),
            Metric(
                id: MetricID.realized.rawValue,
                label: QuoteDetailText.positionRealized,
                value: realizedGain.formattedSigned(),
                trend: GainTrend(realizedGain.amount)
            ),
        ] + currencyEffectMetrics + [
            Metric(
                id: MetricID.totalReturn.rawValue,
                label: QuoteDetailText.positionTotalReturn(
                    totalReturnPercent.formatted(.signedPercent)
                ),
                value: totalReturn.formattedSigned(),
                trend: GainTrend(totalReturn.amount)
            )
        ]
    }
}

private extension Position {
    enum MetricID: String {
        case value
        case gain
        case price
        case gainPercent
        case shares
        case today
        case realized
        case currencyEffect
        case totalReturn
    }

    var isInBaseCurrency: Bool {
        price.currency == costBasis.currency
    }

    var averageCostInPriceCurrency: Money {
        switch isInBaseCurrency {
        case true:
            averageCost
        case false:
            averageLocalCost
        }
    }

    var currencyEffectMetrics: [Metric] {
        switch isInBaseCurrency {
        case true:
            []
        case false:
            [
                Metric(
                    id: MetricID.currencyEffect.rawValue,
                    label: QuoteDetailText.positionCurrencyEffect,
                    value: currencyEffect.formattedSigned(),
                    trend: GainTrend(currencyEffect.amount)
                )
            ]
        }
    }
}
