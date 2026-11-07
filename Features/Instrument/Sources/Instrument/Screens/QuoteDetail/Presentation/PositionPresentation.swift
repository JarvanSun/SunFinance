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
                label: .init(
                    "quoteDetail.position.buyIn \(costBasis.formatted())",
                    bundle: .module
                ),
                value: marketValue.formatted()
            ),
            Metric(
                id: MetricID.gain.rawValue,
                label: .init("quoteDetail.position.sinceBuy", bundle: .module),
                value: unrealizedGain.formattedSigned(),
                trend: GainTrend(unrealizedGain.amount)
            ),
            Metric(
                id: MetricID.price.rawValue,
                label: .init(
                    "quoteDetail.position.averageBuyIn \(averageCostInPriceCurrency.formatted())",
                    bundle: .module
                ),
                value: price.formatted()
            ),
            Metric(
                id: MetricID.gainPercent.rawValue,
                label: .init(
                    "quoteDetail.position.sinceBuyPercent",
                    bundle: .module
                ),
                value: unrealizedGainPercent.formatted(.signedPercent),
                trend: GainTrend(unrealizedGain.amount)
            ),
            Metric(
                id: MetricID.shares.rawValue,
                label: .init("quoteDetail.position.shares", bundle: .module),
                value: quantity.formattedQuantity()
            ),
            Metric(
                id: MetricID.today.rawValue,
                label: .init("quoteDetail.position.today", bundle: .module),
                value: todayGain.formattedSigned(),
                trend: GainTrend(todayGain.amount)
            ),
            Metric(
                id: MetricID.realized.rawValue,
                label: .init("quoteDetail.position.realized", bundle: .module),
                value: realizedGain.formattedSigned(),
                trend: GainTrend(realizedGain.amount)
            ),
        ] + currencyEffectMetrics + [
            Metric(
                id: MetricID.totalReturn.rawValue,
                label: .init(
                    "quoteDetail.position.totalReturnPercent \(totalReturnPercent.formatted(.signedPercent))",
                    bundle: .module
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
                    label: .init(
                        "quoteDetail.position.currencyEffect",
                        bundle: .module
                    ),
                    value: currencyEffect.formattedSigned(),
                    trend: GainTrend(currencyEffect.amount)
                )
            ]
        }
    }
}
